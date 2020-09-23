settingspagemodule = {name: "settingspagemodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["settingspagemodule"]?  then console.log "[settingspagemodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region localMOdules
utl = null
state = null
slideinModule = null

#endregion

############################################################
idContent = null

############################################################
settingspagemodule.initialize = () ->
    log "settingspagemodule.initialize"
    utl = allModules.utilmodule
    state = allModules.statemodule
    slideinModule = allModules.slideinframemodule
    # settingspageContent.
    slideinModule.wireUp(settingspageContent, clearContent, applyContent)

    ##for debugging    
    # settingspagemodule.slideIn()

    idContent = idDisplay.getElementsByClassName("display-frame-content")[0]
    idDisplay.addEventListener("click", idDisplayClicked)

    syncIdFromState()
    syncSecretManagerURLFromState()
    syncDataManagerURLFromState()
    state.addOnChangeListener("publicKeyHex", syncIdFromState)
    state.addOnChangeListener("secretManagerURL", syncSecretManagerURLFromState)
    state.addOnChangeListener("dataManagerURL", syncDataManagerURLFromState)
    return

############################################################
#region internalFunctions
idDisplayClicked = ->
    log "idDisplayClicked"
    utl.copyToClipboard(idContent.textContent)
    return

############################################################
clearContent = ->
    log "clearContent"
    syncIdFromState()
    syncSecretManagerURLFromState()
    syncDataManagerURLFromState()
    return

applyContent = ->
    log "applyContent"
    secretManagerURL = secretManagerInput.value
    dataManagerURL = dataManagerInput.value
    state.setSilently("secretManagerURL", secretManagerURL)
    state.setSilently("dataManagerURL", dataManagerURL)
    state.saveAll()
    return

############################################################
syncIdFromState = ->
    log "syncIdFromState"
    idHex = state.load("publicKeyHex")
    settingspagemodule.displayId(idHex)
    return

syncSecretManagerURLFromState = ->
    log "syncSecretManagerURLFromState"
    secretManagerURL = state.load("secretManagerURL")
    settingspagemodule.displaySecretManagerURL(secretManagerURL)
    return

syncDataManagerURLFromState = ->
    log "syncDataManagerURLFromState"
    dataManagerURL = state.load("dataManagerURL")
    settingspagemodule.displayDataManagerURL(dataManagerURL)
    return

#endregion

############################################################
#region exposedFunctions
settingspagemodule.displayId = (idHex) ->
    log "settingspagemodule.displayId"
    idContent.textContent = "0x" + idHex
    return

settingspagemodule.displaySecretManagerURL = (url) ->
    log "settingspagemodule.displaySecretManager"
    secretManagerInput.value = url
    return

settingspagemodule.displayDataManagerURL = (url) ->
    log "settingspagemodule.displayDataManager"
    dataManagerInput.value = url
    return


############################################################
settingspagemodule.slideOut = ->
    log "darlingspage.slideOut"
    slideinModule.slideoutForContentElement(settingspageContent)
    return

settingspagemodule.slideIn = ->
    log "settingspagemodule.slideIn"
    slideinModule.slideinForContentElement(settingspageContent)
    return

#endregion

module.exports = settingspagemodule