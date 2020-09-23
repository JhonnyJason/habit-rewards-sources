scoremodule = {name: "scoremodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["scoremodule"]?  then console.log "[scoremodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region localModules
state = null
network = null
darlingsPage = null

#endregion


############################################################
scoremodule.initialize = () ->
    log "scoremodule.initialize"
    state = allModules.statemodule
    return

############################################################
#region exposedFunctions
scoremodule.addScore = (score) ->
    log "scoremodule.addScore"
    return unless state.load("darlingAddress")

    darlingScore = state.load("darlingScore")
    newScoreNumber = parseInt(score) + parseInt(darlingScore)
    newScore = "" + newScoreNumber

    state.save("darlingScore", newScore)
    return

#endregion

module.exports = scoremodule