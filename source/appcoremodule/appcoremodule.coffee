appcoremodule = {name: "appcoremodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["appcoremodule"]?  then console.log "[appcoremodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region Modules
secretManagerClientFactory = require("secret-manager-client")

############################################################
state = null

#endregion

############################################################
#region internalProperties
secretManagerClient = null

privateScore = ""

#endregion

############################################################
appcoremodule.initialize = ->
    log "appcoremodule.initialize"
    state = allModules.statemodule

    state.addOnChangeListener("privateScore", onPrivateScoreChanged)
    state.addOnChangeListener("secretManagerURL", onServerURLChanged)
    return
    
############################################################
#region internalFunctions
onPrivateScoreChanged = ->
    log "onPrivateScoreChanged"
    privateScore = state.load("privateScore")
    syncScoreToSecretManager()
    return

onServerURLChanged = -> 
    log "onServerURLChanged"
    serverURL = state.load("secretManagerURL")
    secretManagerClient.updateServerURL(serverURL)
    return

############################################################
syncScoreToSecretManager = ->
    log "syncScoreToSecretManager"
    try
        await secretManagerClient.setSecret("privateScore", privateScore)
    catch err then log err.stack
    return

#endregion

############################################################
#region exposedFunctions
appcoremodule.startUp = ->
    log "appcoremodule.startUp"
    secretKey = state.load("secretKeyHex")
    publicKey = state.load("publicKeyHex")
    serverURL = state.load("secretManagerURL")
    
    secretManagerClient = await secretManagerClientFactory.createClient(secretKey, publicKey, serverURL)

    ## for the case we just created new keys - like when they were missing :-)
    if secretManagerClient.secretKeyHex != secretKey 
        state.save("secretKeyHex", secretManagerClient.secretKeyHex)
    if secretManagerClient.publicKeyHex != publicKey
        state.save("publicKeyHex", secretManagerClient.publicKeyHex)

    privateScore = state.load("privateScore")
    return

#endregion

module.exports = appcoremodule