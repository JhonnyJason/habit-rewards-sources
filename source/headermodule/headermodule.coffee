headermodule = {name: "headermodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["headermodule"]?  then console.log "[headermodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
state = null

############################################################
headermodule.initialize = ->
    log "headermodule.initialize"
    state = allModules.statemodule

    headerRight.addEventListener("click", allModules.settingspagemodule.slideIn)

    syncScoreFromState()
    state.addOnChangeListener("privateScore", syncScoreFromState)
    return
    
############################################################
syncScoreFromState = ->
    score = state.load("privateScore")
    privateScoreDisplay.textContent = score
    return

module.exports = headermodule