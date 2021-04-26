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
state = null
slideinModule = null

#endregion


############################################################
settingspagemodule.initialize = () ->
    log "settingspagemodule.initialize"
    state = allModules.statemodule
    slideinModule = allModules.slideinframemodule

    # settingspageContent.
    slideinModule.wireUp(settingspageContent, clearContent, applyContent)


    syncSecretManagerURLFromState()
    syncDataManagerURLFromState()
    state.addOnChangeListener("secretManagerURL", syncSecretManagerURLFromState)
    state.addOnChangeListener("dataManagerURL", syncDataManagerURLFromState)
    return

############################################################
#region internalFunctions
clearContent = ->
    log "clearContent"
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
    log "settingspagemodule.slideOut"
    slideinModule.slideoutForContentElement(settingspageContent)
    return

settingspagemodule.slideIn = ->
    log "settingspagemodule.slideIn"
    slideinModule.slideinForContentElement(settingspageContent)
    return

#endregion

module.exports = settingspagemodule