deedsmodule = {name: "deedsmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["deedsmodule"]?  then console.log "[deedsmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
mustache = require "mustache"

############################################################
state = null
scoreModule = null
editPage = null

############################################################
touchTimeoutMS = 1000
deedHTMLTemplate = ""
defaultContentHTML = ""

############################################################
touchedDeed = null
touchTimerId = null

############################################################
deedsmodule.initialize = () ->
    log "deedsmodule.initialize"
    state = allModules.statemodule
    editPage = allModules.editdeedpagemodule
    scoreModule = allModules.scoremodule
    
    deedHTMLTemplate = deedviewHiddenTemplate.innerHTML
    defaultContentHTML = deeds.innerHTML

    syncDeedsFromState()
    state.addOnChangeListener("deedIds", syncDeedsFromState)

    ## disable dragging
    deeds.ondragover = (event) -> event.preventDefault()
    return

############################################################
#region internalFunctions
syncDeedsFromState = ->
    log "syncDeedsFromState"
    allIds = state.load("deedIds")
    
    if !allIds? or allIds.length == 0
        deeds.innerHTML = defaultContentHTML
        return

    deedsContentHTML = ""

    for id in allIds when deedObject = state.load(id)
        deedsContentHTML += createDeedHTML(deedObject)

    # olog deedsContentHTML
    deeds.innerHTML = deedsContentHTML
    
    attachFunctionsToDeeds()
    return

############################################################
createDeedHTML = (deedObject) -> mustache.render(deedHTMLTemplate,deedObject)

createDeedUpdateFunction = (deedId, viewElement) ->
    return () ->
        deedObject = state.load(deedId)
        deedText = viewElement.getElementsByClassName("deed-text")[0]
        deedText.textContent = deedObject.deedText
        return

############################################################
attachFunctionsToDeeds = ->
    log "attachFunctionsToDeeds"
    allDeeds = deeds.getElementsByClassName("deed")

    for deed in allDeeds
        deed.addEventListener("click", deedClicked)
        deed.addEventListener("touchstart", deedTouchStarted)
        deed.addEventListener("touchend", deedTouchEnded)
        
        deed.addEventListener("mousedown", deedTouchStarted)
        deed.addEventListener("mouseup", deedTouchEnded)
        deed.addEventListener("mouseleave", deedTouchEnded)

        id = deed.getAttribute("deed-id")
        updateFunction = createDeedUpdateFunction(id, deed)
        state.addOnChangeListener(id, updateFunction)
    return

############################################################
editActivated = ->
    log "editActivated"
    editPage.startEdit(touchedDeed)
    deedTouchEnded()
    return

############################################################
deedClicked = (event) ->
    log "deedClicked"
    id = event.target.getAttribute("deed-id")
    deedObject = state.load(id)
    olog deedObject
    score = deedObject.scoreToAdd
    olog scoreModule
    scoreModule.addScore(score)
    return 

deedTouchStarted = ->
    log "deedTouchStarted"
    if touchTimerId then clearTimeout(touchTimerId)
    touchedDeed = event.target.getAttribute("deed-id")
    touchTimerId = setTimeout(editActivated, touchTimeoutMS)
    return

deedTouchEnded = ->
    log "deedTouchEnded"
    if touchTimerId then clearTimeout(touchTimerId)
    touchedDeed = null
    touchTimerId = null
    return

#endregion

############################################################
#region exposedFunctions
deedsmodule.getTextEdit = (parent) ->
    return parent.getElementsByClassName("deed-text-edit")[0]

deedsmodule.addNewDeed = (deedText, scoreToAdd) ->
    id = state.load("nextDeedId") || "" + 0
    allIds = state.load("deedIds")
    
    if allIds? then allIds = [allIds...]
    else allIds = []
    allIds.push id
    

    number = parseInt(id)
    number++
    nextDeedId = "" + number 

    newDeedObject = {id, deedText, scoreToAdd}

    state.save("nextDeedId", nextDeedId)
    state.save(id, newDeedObject)
    state.save("deedIds", allIds)
    return

#endregion

module.exports = deedsmodule