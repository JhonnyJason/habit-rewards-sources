networkmodule = {name: "networkmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["networkmodule"]?  then console.log "[networkmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
state = null
auth = null

############################################################
networkmodule.initialize = () ->
    log "networkmodule.initialize"
    state = allModules.statemodule
    auth = allModules.authmodule
    return

############################################################
#region internalFunctions
postData = (url, data) ->
    options =
        method: 'POST'
        credentials: 'omit'
        body: JSON.stringify(data)
        headers:
            'Content-Type': 'application/json'

    response = await fetch(url, options)
    if response.status == 403 then throw new Error("Unauthorized!")
    return response.json()

############################################################
#region packageProducerFunctions
createAddNodeIdPackage = (publicKeyHex) ->
    log "createAddNodeIdPackage"
    payload = 
        publicKey: publicKeyHex
        timestamp: ""
    return payload

createGetSecretSpacePackage = (publicKeyHex) ->
    log "createGetSecretSpacePackage"
    payload = 
        publicKey: publicKeyHex
        timestamp: ""
    return payload

############################################################
createSetSecretPackage = (secret, id, publicKeyHex) ->
    log "createSetSecretPackage"
    payload =
        publicKey: publicKeyHex
        secretId: id
        secret: secret
        timestamp: ""
    return payload

createGetSecretPackage = (id, publicKeyHex) ->
    log "createGetSecretPackage"
    payload = 
        publicKey: publicKeyHex
        secretId: id
        timestamp: ""
    return payload

createDeleteSecretPackage = (id, publicKeyHex) ->
    log "createGetSecretPackage"
    payload = 
        publicKey: publicKeyHex
        secretId: id
        timestamp: ""
    return payload

############################################################
createStartAcceptingSecretsFromPackage = (fromAddress, publicKeyHex) ->
    log "createStartSharingSecretToPackage"
    payload =
        publicKey: publicKeyHex
        fromId: fromAddress
        timestamp: ""
    return payload

createStopAcceptingSecretsFromPackage = (fromAddress, publicKeyHex) ->
    log "createStartSharingSecretToPackage"
    payload =
        publicKey: publicKeyHex
        fromId: fromAddress
        timestamp: ""
    return payload

############################################################
createStartSharingSecretToPackage = (toAddress, id, publicKeyHex) ->
    log "createStartSharingSecretToPackage"
    payload =
        publicKey: publicKeyHex
        shareToId: toAddress
        secretId: id
        timestamp: ""
    return payload

createStopSharingSecretToPackage = (toAddress, id, publicKeyHex) ->
    log "createStartSharingSecretToPackage"
    payload =
        publicKey: publicKeyHex
        sharedToId: toAddress
        secretId: id
        timestamp: ""
    return payload

#endregion

#endregion

############################################################
#region exposedFunctions
networkmodule.addNodeId = (publicKeyHex) ->
    log "networkmodule.addNodeId"
    log publicKeyHex
    payload = createAddNodeIdPackage(publicKeyHex)
    payload = await auth.signPayload(payload)

    url = state.load("secretManagerURL") + "/addNodeId"
    log url
    olog payload
    return await postData(url, payload)
    
networkmodule.getSecretSpace = (publicKeyHex) ->
    log publicKeyHex
    payload = createGetSecretSpacePackage(publicKeyHex)
    payload = await auth.signPayload(payload)

    url = state.load("secretManagerURL") + "/getSecretSpace"
    log url
    olog payload
    return await postData(url, payload)

############################################################
networkmodule.setSecret = (secret, key, publicKeyHex) ->
    log "networkmodule.setSecret"
    payload = createSetSecretPackage(secret, key, publicKeyHex)
    payload = await auth.signPayload(payload)

    url = state.load("secretManagerURL") + "/setSecret"
    log url
    olog payload
    return await postData(url, payload)

networkmodule.getSecret = (key, publicKeyHex) ->
    log "networkmodule.getSecret"
    payload = createGetSecretPackage(key,publicKeyHex)
    payload = await auth.signPayload(payload)

    url = state.load("secretManagerURL") + "/getSecret"
    log url
    olog payload
    return await postData(url, payload)

networkmodule.deleteSecret = (key, publicKeyHex) ->
    log "networkmodule.deleteSecret"
    payload = createDeleteSecretPackage(key,publicKeyHex)
    payload = await auth.signPayload(payload)

    url = state.load("secretManagerURL") + "/deleteSecret"
    log url
    olog payload
    return await postData(url, payload)

############################################################
networkmodule.startAcceptingSecretsFrom = (address, publicKeyHex) ->
    log "networkmodule.startSharingSecretTo"
    payload = createStartAcceptingSecretsFromPackage(address, publicKeyHex)
    payload = await auth.signPayload(payload)

    url = state.load("secretManagerURL") + "/startAcceptingSecretsFrom"
    log url
    olog payload
    return await postData(url, payload)

networkmodule.stopAcceptingSecretsFrom = (address, publicKeyHex) ->
    log "networkmodule.stopSharingSecretTo"
    payload = createStopAcceptingSecretsFromPackage(address, publicKeyHex)
    payload = await auth.signPayload(payload)

    url = state.load("secretManagerURL") + "/stopAcceptingSecretsFrom"
    log url
    olog payload
    return await postData(url, payload)

############################################################
networkmodule.startSharingSecretTo = (toAddress, key, publicKeyHex) ->
    log "networkmodule.startSharingSecretTo"
    payload = createStartSharingSecretToPackage(toAddress,key,publicKeyHex)
    payload = await auth.signPayload(payload)

    url = state.load("secretManagerURL") + "/startSharingSecretTo"
    log url
    olog payload
    return await postData(url, payload)

networkmodule.stopSharingSecretTo = (toAddress, key, publicKeyHex) ->
    log "networkmodule.stopSharingSecretTo"
    payload = createStopSharingSecretToPackage(toAddress,key,publicKeyHex)
    payload = await auth.signPayload(payload)

    url = state.load("secretManagerURL") + "/stopSharingSecretTo"
    log url
    olog payload
    return await postData(url, payload)

#endregion

module.exports = networkmodule