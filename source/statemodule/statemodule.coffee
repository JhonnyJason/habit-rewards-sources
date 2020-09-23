statemodule = {name: "statemodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["statemodule"]?  then console.log "[statemodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
defaultState =
    darlingAddress: ""
    darlingScore: ""
    darlingIsConnected: false
    myScore: ""
    secretManagerURL: "https://secrets.extensivlyon.coffee"
    # secretManagerURL: "https://localhost:6999" 
    dataManagerURL: "https://data.extensivlyon.coffee"
    # dataManagerURL: "https://localhost:6999" 
    secretKeyHex: ""
    publicKeyHex: ""
    nextDeedId: "0"
    deedIds: []


############################################################
state = localStorage.getItem("state")
if state then state = JSON.parse(state)
else state = defaultState

############################################################
listeners = {}

############################################################
statemodule.initialize = () ->
    log "statemodule.initialize"
    return

############################################################
#region internalFunctions
saveState = ->
    log "saveState"
    stateString = JSON.stringify(state)
    localStorage.setItem("state", stateString)
    return

callOnChangeListeners = (key) ->
    log "callOnChangeListeners"
    return if !listeners[key]?
    promises = (fun() for fun in listeners[key])
    await Promise.all(promises)
    return

#endregion

############################################################
#region exposedFunctions
statemodule.getState = -> state

############################################################
statemodule.removeOnChangeListener = (key, fun) ->
    log "statemodule.removeOnChangeListener"
    candidates = listeners[key]
    if candidates?
        for candidate,i in candidates when candidates == fun
            log "candidate found at: " + i
            candidates[i] = candidates[candidates.length - 1]
            candidates.pop()
            return
        log "No candidate found for given function!"
    return

statemodule.addOnChangeListener = (key, fun) ->
    log "statemodule.addOnChangeListener"
    if !listeners[key]? then listeners[key] = []
    listeners[key].push(fun)
    return

statemodule.callOutChange = (key) ->
    log "statemodule.callOutChange"
    try await callOnChangeListeners(key)
    catch err then log err
    return

############################################################
#region stateSetterFunctions
statemodule.saveAll = saveState

############################################################
statemodule.save = (key, content) ->
    log "statemodule.save"
    return if state[key] == content
    state[key] = content
    saveState()
    await statemodule.callOutChange(key)
    return

statemodule.saveSilently = (key, content) ->
    log "statemodule.saveSilently"
    return if state[key] == content
    state[key] = content
    saveState()
    return

statemodule.set = (key, content) ->
    log "statemodule.set"
    return if state[key] == content
    state[key] = content
    await statemodule.callOutChange(key)
    return

statemodule.setSilently = (key, content) ->
    log "statemodule.setSilently"
    return if state[key] == content
    state[key] = content
    return

#endregion

############################################################
statemodule.load = (key) -> state[key]

#endregion

module.exports = statemodule



