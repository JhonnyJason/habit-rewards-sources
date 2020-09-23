edithabitpagemodule = {name: "edithabitpagemodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["edithabitpagemodule"]?  then console.log "[edithabitpagemodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
state = null
habits = null
pointAdd = null
slideinModule = null

############################################################
habitEditPointInput = null
habitTextEdit = null

############################################################
currentHabitObject = null

############################################################
edithabitpagemodule.initialize = () ->
    log "edithabitpagemodule.initialize"
    state = allModules.statemodule
    habits = allModules.habitsmodule
    pointAdd = allModules.pointaddmodule
    slideinModule = allModules.slideinframemodule
    # edithabitpageContent.
    slideinModule.wireUp(edithabitpageContent, clearContent, applyContent)

    habitEditPointInput = pointAdd.setup(edithabitpageContent)
    habitTextEdit = habits.getTextEdit(edithabitpageContent)

    clearContent()

    deleteButton.addEventListener("click", deleteButtonClicked)
    return

############################################################
deleteButtonClicked = ->
    log "deleteButtonClicked"
    idToDelete = currentHabitObject.id
    log "idToDelete"
    log idToDelete
    allIds = state.load("habitIds")
    log "allIds"
    olog allIds
    newIds = allIds.filter((id) -> id != idToDelete)
    log "newIds"
    olog newIds
    state.save("habitIds", newIds)

    clearContent()
    edithabitpagemodule.slideOut()
    return

clearContent = ->
    log "clearContent"
    habitEditPointInput.value = 0
    habitTextEdit.textContent = ""
    currentHabitObject = null
    return

applyContent = ->
    log "applyContent"
    currentHabitObject.habitText = habitTextEdit.textContent
    currentHabitObject.scoreToAdd = habitEditPointInput.value
    state.save(currentHabitObject.id, currentHabitObject)
    clearContent()
    return

############################################################
#region exposedFunctions
edithabitpagemodule.slideOut = ->
    log "edithabitpagemodule.slideOut"
    slideinModule.slideoutForContentElement(edithabitpageContent)
    return

edithabitpagemodule.slideIn = ->
    log "edithabitpagemodule.slideIn"
    slideinModule.slideinForContentElement(edithabitpageContent)
    return

edithabitpagemodule.startEdit = (habitId) ->
    log "edithabitpagemodule.startEdit"
    currentHabitObject = Object.assign({}, state.load(habitId))
    habitEditPointInput.value = currentHabitObject.scoreToAdd
    habitTextEdit.textContent = currentHabitObject.habitText
    edithabitpagemodule.slideIn()
    return

#endregion
    
module.exports = edithabitpagemodule