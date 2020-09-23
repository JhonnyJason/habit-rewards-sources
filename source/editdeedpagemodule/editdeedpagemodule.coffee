editdeedpagemodule = {name: "editdeedpagemodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["editdeedpagemodule"]?  then console.log "[editdeedpagemodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
state = null
deeds = null
pointAdd = null
slideinModule = null

############################################################
deedEditPointInput = null
deedTextEdit = null

############################################################
currentDeedObject = null

############################################################
editdeedpagemodule.initialize = () ->
    log "editdeedpagemodule.initialize"
    state = allModules.statemodule
    deeds = allModules.deedsmodule
    pointAdd = allModules.pointaddmodule
    slideinModule = allModules.slideinframemodule
    # editdeedpageContent.
    slideinModule.wireUp(editdeedpageContent, clearContent, applyContent)

    deedEditPointInput = pointAdd.setup(editdeedpageContent)
    deedTextEdit = deeds.getTextEdit(editdeedpageContent)

    clearContent()

    deleteButton.addEventListener("click", deleteButtonClicked)
    return

############################################################
deleteButtonClicked = ->
    log "deleteButtonClicked"
    idToDelete = currentDeedObject.id
    log "idToDelete"
    log idToDelete
    allIds = state.load("deedIds")
    log "allIds"
    olog allIds
    newIds = allIds.filter((id) -> id != idToDelete)
    log "newIds"
    olog newIds
    state.save("deedIds", newIds)

    clearContent()
    editdeedpagemodule.slideOut()
    return

clearContent = ->
    log "clearContent"
    deedEditPointInput.value = 0
    deedTextEdit.textContent = ""
    currentDeedObject = null
    return

applyContent = ->
    log "applyContent"
    currentDeedObject.deedText = deedTextEdit.textContent
    currentDeedObject.scoreToAdd = deedEditPointInput.value
    state.save(currentDeedObject.id, currentDeedObject)
    clearContent()
    return

############################################################
#region exposedFunctions
editdeedpagemodule.slideOut = ->
    log "editdeedpagemodule.slideOut"
    slideinModule.slideoutForContentElement(editdeedpageContent)
    return

editdeedpagemodule.slideIn = ->
    log "editdeedpagemodule.slideIn"
    slideinModule.slideinForContentElement(editdeedpageContent)
    return

editdeedpagemodule.startEdit = (deedId) ->
    log "editdeedpagemodule.startEdit"
    currentDeedObject = Object.assign({}, state.load(deedId))
    deedEditPointInput.value = currentDeedObject.scoreToAdd
    deedTextEdit.textContent = currentDeedObject.deedText
    editdeedpagemodule.slideIn()
    return

#endregion
    
module.exports = editdeedpagemodule