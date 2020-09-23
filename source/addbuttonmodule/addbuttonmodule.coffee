addbuttonmodule = {name: "addbuttonmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["addbuttonmodule"]?  then console.log "[addbuttonmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
newHabitPage = null

############################################################
addbuttonmodule.initialize = () ->
    log "addbuttonmodule.initialize"
    newHabitPage = allModules.newhabitpagemodule
    addbutton.addEventListener("click", addbuttonClicked)
    return


############################################################
addbuttonClicked = -> newHabitPage.slideIn()


module.exports = addbuttonmodule