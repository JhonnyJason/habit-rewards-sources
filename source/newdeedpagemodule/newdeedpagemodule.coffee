newdeedpagemodule = {name: "newdeedpagemodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["newdeedpagemodule"]?  then console.log "[newdeedpagemodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
deeds = null
pointAdd = null
slideinModule = null


############################################################
deedEditPointInput = null
deedTextEdit = null

defaultDeedText = "Edit here!"

############################################################
newdeedpagemodule.initialize = () ->
    log "newdeedpagemodule.initialize"
    deeds = allModules.deedsmodule
    pointAdd = allModules.pointaddmodule
    slideinModule = allModules.slideinframemodule
    # newdeedpageContent.
    slideinModule.wireUp(newdeedpageContent, clearContent, applyContent)

    deedEditPointInput = pointAdd.setup(newdeedpageContent)
    deedTextEdit = deeds.getTextEdit(newdeedpageContent)
    
    clearContent()
    return

############################################################
clearContent = ->
    log "clearContent"
    deedEditPointInput.value = 0
    deedTextEdit.textContent = defaultDeedText
    return

applyContent = ->
    log "applyContent"
    deedText = deedTextEdit.textContent
    pointsToAdd = deedEditPointInput.value
    deeds.addNewDeed(deedText, pointsToAdd)
    clearContent()
    return

############################################################
#region exposedFunctions
newdeedpagemodule.slideOut = ->
    log "newdeedpagemodule.slideOut"
    slideinModule.slideoutForContentElement(newdeedpageContent)
    return

newdeedpagemodule.slideIn = ->
    log "newdeedpagemodule.slideIn"
    slideinModule.slideinForContentElement(newdeedpageContent)
    return
#endregion
    
module.exports = newdeedpagemodule