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

    headerLeft.addEventListener("click", allModules.darlingspagemodule.slideIn)
    headerCenter.addEventListener("click", allModules.manualaddframemodule.slideIn)
    headerRight.addEventListener("click", allModules.settingspagemodule.slideIn)

    syncScoreFromState()
    state.addOnChangeListener("darlingScore", syncScoreFromState)
    return
    
############################################################
syncScoreFromState = ->
    score = state.load("darlingScore")
    darlingScoreDisplay.textContent = score
    return

module.exports = headermodule