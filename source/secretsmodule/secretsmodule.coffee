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
    
    state.addOnChangeListener("privateScore", syncScoreToSecretManager)
    return
    
############################################################
#region internalFunctions
syncScoreToSecretManager = ->
    log "syncScoreToSecretManager"
    publicKeyHex = state.load("publicKeyHex")
    score = state.load("privateScore")
    log "score: " + score

    log "... setting privateScore"
    response = await network.setSecret(score, "privateScore", publicKeyHex)
    olog response
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

    privateScore = await extractSecret("privateScore")
    if !privateScore then state.setSilently("privateScore", "")
    else state.setSilently("privateScore", privateScore)
    
    log "did set the extracted secrets.."
    return

applyStateChanges = ->
    log "applyStateChanges"
    
    ## apply the potential state changes
    promises = []
    promises.push state.callOutChange("privateScore")
    await Promise.all(promises)
    state.saveAll()
    return

############################################################
unsetState = ->
    allIds = []
    nextHabitId = "0"
    promises.push state.set("privateScore", "")
    await Promise.all(promises)
    
    state.saveAll()
    return

unsetSecrets = ->
    log "unsetSecrets"
    publicKeyHex = state.load("publicKeyHex")

    log "...delete privateScore as secret"
    response = await network.deleteSecret("privateScore", publicKeyHex)
    olog response
    return

setNewSecrets = ->
    log "setNewprivateSecrets"
    publicKeyHex = state.load("publicKeyHex")

    privateScore = "" + 0
    state.save("privateScore", privateScore)
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

    privateScore = state.load("privateScore")
    if !privateScore? then setNewSecrets()
    return

#endregion

module.exports = secretsmodule