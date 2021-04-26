appcoremodule = {name: "appcoremodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["appcoremodule"]?  then console.log "[appcoremodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region Modules
state = null
accountSettings = null

#endregion

############################################################
#region internalProperties
client = null

privateScore = ""

accountReset = false

#endregion

############################################################
appcoremodule.initialize = ->
    log "appcoremodule.initialize"
    state = allModules.statemodule
    accountSettings = allModules.accountsettingsmodule

    state.addOnChangeListener("privateScore", onPrivateScoreChanged)
    state.addOnChangeListener("accountId", onAccountChanged)
    return
    
############################################################
#region internalFunctions
onAccountChanged = ->
    log "onAccountChanged"
    client = accountSettings.getClient()
    if client?
        log "we had a client!"
        
        accountReset = true
        try privateScore = await client.getSecret("privateScore")
        catch err
            log err.message
            privateScore = ""
        await state.save("privateScore", privateScore)
        accountReset = false

    else setStateNoAccount()
    return


onPrivateScoreChanged = ->
    log "onPrivateScoreChanged"
    return if accountReset
    if !client? 
        await state.set("privateScore", "")
        log "no client"
        log "privateScore: "+privateScore
        log "state.get('privateScore'): "+state.get("privateScore")
        return
    
    log "with client"
    log "privateScore: "+privateScore
    log "state.get('privateScore'): "+state.get("privateScore")
        
    oldScoreString = privateScore
    privateScore = state.get("privateScore")
    
    os = parseInt(oldScoreString)
    if isNaN(os) then os = 0
    ns = parseInt(privateScore)
    dif = ns - os
    if !isNaN(dif) and dif != 0
        outstandingChanges = state.get("outstandingChanges")|| {privateScore: 0}
        outstandingChanges.privateScore += dif
        state.save("outstandingChanges", outstandingChanges)


    syncScoreToSecretManager()
    state.saveRegularState()
    return


############################################################
syncScoreToSecretManager = ->
    log "syncScoreToSecretManager"
    return unless client?
    try
        await client.setSecret("privateScore", privateScore)
        state.remove("outstandingChanges")
    catch err then log err.stack
    return


############################################################
triadeSync = ->
    log "triadeSync"
    try
        clientPrivateScore = await client.getSecret("privateScore")
        if typeof clientPrivateScore == "number" then clientPrivateScore = ""+clientPrivateScore
    catch err 
        log err.stack
        # probably we are offline -> so no sync
        return

    accountReset = true
    # clientData > localData    
    if clientPrivateScore and clientPrivateScore != privateScore
        privateScore = clientPrivateScore
        await state.save("privateScore", privateScore)
    accountReset = false

    outstandingChanges = state.get("outstandingChanges")
    return unless outstandingChanges?
    state.remove("outstandingChanges")

    changedScore = outstandingChanges.privateScore
    score = parseInt(privateScore)
    if score == NaN then score = 0

    deltaScore = parseInt(changedScore)
    if deltaScore != NaN then score += deltaScore

    accountReset = true
    privateScore = ""+score
    await state.save("privateScore", privateScore)
    accountReset = false
    
    syncScoreToSecretManager()
    return

setStateNoAccount = ->
    log "setStateNoAccount"
    accountReset = true
    privateScore = ""
    await state.save("privateScore", privateScore)
    accountReset = false
    return

#endregion

############################################################
#region exposedFunctions
appcoremodule.startUp = ->
    log "appcoremodule.startUp"
    client = accountSettings.getClient()
    privateScore = state.load("privateScore")
    if client? then await triadeSync()
    else await setStateNoAccount()
    return
#endregion

module.exports = appcoremodule