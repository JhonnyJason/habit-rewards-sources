secretsmodule = {name: "secretsmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["secretsmodule"]?  then console.log "[secretsmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region localModules
utl = null
state = null
network = null
encryption = null

#endregion

############################################################
#region internalProperties
secretSpace = null

#endregion

############################################################
secretsmodule.initialize = () ->
    log "secretsmodule.initialize"
    
    utl = allModules.utilmodule
    state = allModules.statemodule
    network = allModules.networkmodule
    encryption = allModules.encryptionmodule
    return
    
############################################################
#region internalFunctions
syncScoreToSecretManager = ->
    log "syncScoreToSecretManager"
    publicKeyHex = state.load("publicKeyHex")
    score = state.load("darlingScore")
    log "score: " + score

    log "... setting darlingScore"
    response = await network.setSecret(score, "darlingScore", publicKeyHex)
    olog response

    # await secretsmodule.updateSecrets()
    return

############################################################
loadSecretSpace = ->
    log "loadSecretSpace"
    keyHex = state.load("secretKeyHex")
    myId = state.load("publicKeyHex")
    
    # log "retrieveing the secret space..."
    secrets = await network.getSecretSpace(myId)
    
    # olog secrets
    # log "decrypting the data..."
    stringVersion = await encryption.asymetricDecrypt(secrets, keyHex)
    stringVersion = encryption.removeSalt(stringVersion)
    # log stringVersion
    secretSpace = JSON.parse(stringVersion)
    # olog secretSpace
    return

extractSecretsSilently = ->
    log "extractSecretsSilently"

    darlingAddress = await extractSecret("darlingAddress") 
    if !darlingAddress then state.setSilently("darlingAddress","")
    else state.setSilently("darlingAddress", darlingAddress)
    log "extracted darlingAddress"

    darlingScore = await extractSecret("darlingScore")
    if !darlingScore then state.setSilently("darlingScore", "")
    else state.setSilently("darlingScore", darlingScore)
    
    if !darlingAddress then return

    myScore = await extractSharedSecret(darlingAddress, "darlingScore")
    if !myScore 
        state.setSilently("myScore", "")
        state.setSilently("darlingIsConnected", false)
    else 
        state.setSilently("myScore", myScore)
        state.setSilently("darlingIsConnected", true)
    
    log "did set the extracted secrets.."
    return

applyStateChanges = ->
    log "applyStateChanges"
    if !state.load("darlingAddress")
        state.setSilently("darlingAddress", "")
        state.setSilently("darlingScore", "")
        state.setSilently("darlingIsConnected", false)
        state.setSilently("myScore", "")

    ## apply the potential state changes
    promises = []
    promises.push state.callOutChange("darlingAddress")
    promises.push state.callOutChange("darlingScore")
    promises.push state.callOutChange("darlingIsConnected")
    promises.push state.callOutChange("myScore")    
    await Promise.all(promises)
    state.saveAll()
    return

############################################################
unsetState = ->
    allIds = []
    nextDeedId = "0"
    promises.push state.set("darlingAddress", "")
    promises.push state.set("darlingScore", "")
    promises.push state.set("darlingIsConnected", false)
    promises.push state.set("myScore", "")
    await Promise.all(promises)
    
    state.saveAll()
    return

unsetSecrets = ->
    log "unsetSecrets"
    publicKeyHex = state.load("publicKeyHex")

    log "...delete darlingAddress as secret"
    response = await network.deleteSecret("darlingAddress", publicKeyHex)
    olog response
    
    log "...delete darlingScore as secret"
    response = await network.deleteSecret("darlingScore", publicKeyHex)
    olog response

    oldAddress = await extractSecret("darlingAddress")
    return unless oldAddress

    log "...stop accepting sharedSecrets from my darling"
    response = await network.stopAcceptingSecretsFrom(oldAddress, publicKeyHex)
    olog response
    return

disconnectFromDarling = ->
    log "disconnectFromDarling"
    await unsetSecrets()
    await unsetState()
    return

setNewDarlingSecrets = ->
    log "setNewDarlingSecrets"
    publicKeyHex = state.load("publicKeyHex")
    darlingAddress = state.load("darlingAddress")

    log "...set darlingAddress as secret"
    response = await network.setSecret(darlingAddress, "darlingAddress",publicKeyHex)
    olog response

    log "...start accepting sharedSecrets from my darling"
    response = await network.startAcceptingSecretsFrom(darlingAddress, publicKeyHex)
    olog response

    log "...start sharing the darlingScore to my darling"
    response = await network.startSharingSecretTo(darlingAddress, "darlingScore", publicKeyHex)
    olog response

    darlingScore = "" + 0
    state.save("darlingScore", darlingScore)

    log "...set darlingScrore as secret"
    response = await network.setSecret(darlingScore, "darlingScore", publicKeyHex)
    olog response
    return

############################################################
#region secretExtractionFunctions
decryptSecret = (secrets) ->
    keyHex = state.load("secretKeyHex")
    decrypted = await encryption.asymetricDecrypt(secrets, keyHex)
    return encryption.removeSalt(decrypted)

extractSharedSecret = (fromAddress, label) ->
    return null if !secretSpace[fromAddress]?
    return null if !secretSpace[fromAddress][label]?
    return await decryptSecret(secretSpace[fromAddress][label])
    
extractSecret = (label) ->
    return null if !secretSpace[label]?
    return null if !secretSpace[label].secret
    return await decryptSecret(secretSpace[label].secret)

#endregion

#endregion

############################################################
#region exposedFunctions
secretsmodule.updateSecrets = ->
    log "secretsmodule.updateSecrets"
    await loadSecretSpace()
    await extractSecretsSilently()
    await applyStateChanges()

    olog "updated Secrets:"
    olog secretSpace

    darlingAddress = state.load("darlingAddress")
    if darlingAddress then  state.addOnChangeListener("darlingScore", syncScoreToSecretManager)
    else state.removeOnChangeListener("darlingScore", syncScoreToSecretManager)
    return

############################################################
secretsmodule.connectDarling = ->
    log "secretsmodule.connectDarling"
    darlingAddress = state.load("darlingAddress")
    
    if !darlingAddress
        await disconnectFromDarling()
        await secretsmodule.updateSecrets()
        return
    
    try
        oldAddress = await extractSecret("darlingAddress")
        log oldAddress
        log darlingAddress
        if oldAddress == darlingAddress then return

        await setNewDarlingSecrets()
        await secretsmodule.updateSecrets()

    catch err then log err
    return

#endregion

module.exports = secretsmodule