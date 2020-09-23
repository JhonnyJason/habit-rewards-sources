newhabitpagemodule = {name: "newhabitpagemodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["newhabitpagemodule"]?  then console.log "[newhabitpagemodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
habits = null
pointAdd = null
slideinModule = null


############################################################
habitEditPointInput = null
habitTextEdit = null

defaultHabitText = "Edit here!"

############################################################
newhabitpagemodule.initialize = () ->
    log "newhabitpagemodule.initialize"
    habits = allModules.habitsmodule
    pointAdd = allModules.pointaddmodule
    slideinModule = allModules.slideinframemodule
    # newhabitpageContent.
    slideinModule.wireUp(newhabitpageContent, clearContent, applyContent)

    habitEditPointInput = pointAdd.setup(newhabitpageContent)
    habitTextEdit = habits.getTextEdit(newhabitpageContent)
    
    clearContent()
    return

############################################################
clearContent = ->
    log "clearContent"
    habitEditPointInput.value = 0
    habitTextEdit.textContent = defaultHabitText
    return

applyContent = ->
    log "applyContent"
    habitText = habitTextEdit.textContent
    pointsToAdd = habitEditPointInput.value
    habits.addNewHabit(habitText, pointsToAdd)
    clearContent()
    return

############################################################
#region exposedFunctions
newhabitpagemodule.slideOut = ->
    log "newhabitpagemodule.slideOut"
    slideinModule.slideoutForContentElement(newhabitpageContent)
    return

newhabitpagemodule.slideIn = ->
    log "newhabitpagemodule.slideIn"
    slideinModule.slideinForContentElement(newhabitpageContent)
    return
#endregion
    
module.exports = newhabitpagemodule