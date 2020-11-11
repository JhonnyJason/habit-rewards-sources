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

    privateScore = state.load("privateScore")
        
    newScoreNumber = parseInt(score) + parseInt(privateScore)
    newScore = "" + newScoreNumber
    
    if isNaN(newScore) then newScore = 0
    state.save("privateScore", newScore)
    return

#endregion

module.exports = scoremodule