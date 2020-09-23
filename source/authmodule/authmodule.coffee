authmodule = {name: "authmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["authmodule"]?  then console.log "[authmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region modulesFromEnvironment
noble = require("noble-ed25519")

############################################################
#region localmodules
utl = null
state = null
secrets = null
network = null
settingsPage = null

#endregion

#endregion

############################################################
secretKeyHex = ""
publicKeyHex = ""

############################################################
authmodule.initialize = ->
    log "authmodule.initialize"

    utl = allModules.utilmodule
    state = allModules.statemodule
    secrets = allModules.secretsmodule
    network = allModules.networkmodule
    settingsPage = allModules.settingspagemodule

    secretKeyHex = state.load("secretKeyHex")
    publicKeyHex = state.load("publicKeyHex")
    return

############################################################
newSecretBytes = noble.utils.randomPrivateKey

############################################################
#region exposedFunctions
authmodule.startupCheck = ->
    log "authmodule.startupCheck"

    if !secretKeyHex 
        secretKeyHex = utl.bytesToHex(newSecretBytes())
        state.save("secretKeyHex", secretKeyHex)
    if !publicKeyHex
        publicKeyHex = await noble.getPublicKey(secretKeyHex)
        state.save("publicKeyHex", publicKeyHex)

    # check status with secretManager
    try await network.addNodeId(publicKeyHex)
    catch err then log err
    return

authmodule.signPayload = (payload) ->
    log "authmodule.signPayload"
    hashHex = await utl.sha256Hex(JSON.stringify(payload))
    log hashHex
    payload.signature = await noble.sign(hashHex, secretKeyHex)
    return payload

#endregion

module.exports = authmodule