slideinframemodule = {name: "slideinframemodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["slideinframemodule"]?  then console.log "[slideinframemodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
i = slideinframemodule
    
############################################################
slideinframemodule.initialize = ->
    log "slideinframemodule.initialize"
    return

############################################################
slideoutFrame = (frame) ->
    frame.classList.remove("active")
    return

slideinFrame = (frame) ->
    frame.classList.add("active")
    return

############################################################
#region exposedFunctions
slideinframemodule.wireUp = (contentElement, clearContent, applyContent) ->
    frame = i.getFrameForContentElement(contentElement)
    backButton = i.getBackButtonForContentElement(contentElement)
    acceptButton = i.getAcceptButtonForContentElement(contentElement)

    backButtonClicked = ->
        clearContent()
        slideoutFrame(frame)
        return
    acceptButtonClicked = ->
        applyContent()
        slideoutFrame(frame)
        return

    backButton.addEventListener("click", backButtonClicked)
    acceptButton.addEventListener("click", acceptButtonClicked)
    return

############################################################
slideinframemodule.slideinForContentElement = (contentElement) ->
    frame = i.getFrameForContentElement(contentElement)
    slideinFrame(frame)
    return

slideinframemodule.slideoutForContentElement = (contentElement) ->
    frame = i.getFrameForContentElement(contentElement)
    slideoutFrame(frame)
    return

############################################################
#region getElementsFunctions
slideinframemodule.getFrameForContentElement = (contentElement) ->
    return contentElement.parentElement.parentElement

slideinframemodule.getBackButtonForContentElement = (contentElement) ->
    frame = contentElement.parentElement.parentElement
    return frame.getElementsByClassName("slideinframe-back-button")[0]

slideinframemodule.getAcceptButtonForContentElement = (contentElement) ->
    frame = contentElement.parentElement.parentElement
    return frame.getElementsByClassName("slideinframe-accept-button")[0]

#endregion

#endregion

module.exports = slideinframemodule