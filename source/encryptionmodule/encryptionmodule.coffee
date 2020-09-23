encryptionmodule = {name: "encryptionmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["encryptionmodule"]?  then console.log "[encryptionmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
noble = require("noble-ed25519")
crypto = window.crypto.subtle

############################################################
utl = null

############################################################
encryptionmodule.initialize = () ->
    log "encryptionmodule.initialize"
    utl = allModules.utilmodule
    return

############################################################
#region internalFunctions
hashToScalar = (byteBuffer) ->
    relevant = new Uint8Array(byteBuffer.slice(0, 32))
    relevant[0] &= 248
    relevant[31] &= 127
    relevant[31] |= 64
    return utl.bytesToBigInt(relevant.buffer)

createKeyObject = (keyHex) ->
    keyBuffer = utl.hexToBytes(keyHex)
    return await crypto.importKey("raw", keyBuffer, {name:"AES-CBC"}, false, ["decrypt", "encrypt"])

#endregion

############################################################
#region exposedFunctions
encryptionmodule.createRandomLengthSalt = ->
    bytes = new Uint8Array(512)
    loop
        window.crypto.getRandomValues(bytes)
        for byte,i in bytes when byte == 0
            return bytes.slice(0,i+1).toString("utf8")        


encryptionmodule.removeSalt = (content) ->
    for char,i in content when char == "\0"
        return content.slice(i+1)
    throw new Error("No Salt termination found!")    

############################################################
encryptionmodule.asymetricEncrypt = (content, publicKeyHex) ->
    # a = Private Key
    # k = utl.sha512Bytes(a) -> hashToScalar
    # G = basePoint
    # B = kG = Public Key
    B = noble.Point.fromHex(publicKeyHex)
    BHex = publicKeyHex
    # log "BHex: " + BHex

    # n = new one-time secret (generated on sever and forgotten about)
    # l = utl.sha512Bytes(n) -> hashToScalar
    # lB = lkG = shared secret
    # key = utl.sha512Bytes(lBHex)
    # X = symetricEncrypt(content, key)
    # A = lG = one time public reference point
    # {A,X} = data to be stored for B

    # n = one-time secret
    nBytes = noble.utils.randomPrivateKey()
    nHex = utl.bytesToHex(nBytes)
    nHashed = await utl.sha512Bytes(nBytes)
    lBigInt = hashToScalar(nHashed)
    # log lBigInt
    
    #A one time public key = reference Point
    AHex = await encryptionmodule.getPublic(nHex)
    
    lB = await B.multiply(lBigInt)
    
    ## TODO generate AES key
    symkeyHex = await utl.sha512Hex(lB.toHex())
    gibbrish = encryptionmodule.symetricEncryptHex(content, symkeyHex)
    
    referencePoint = AHex
    encryptedContent = gibbrish

    return {referencePoint, encryptedContent}

encryptionmodule.asymetricDecrypt = (secrets, privateKeyHex) ->
    if !secrets.referencePoint? or !secrets.encryptedContent?
        throw new Error("unexpected secrets format!")
    # a = Private Key
    # k = utl.sha512Bytes(a) -> hashToScalar
    # G = basePoint
    # B = kG = Public Key

    aBytes = utl.hexToBytes(privateKeyHex)
    aHashed = await utl.sha512Bytes(aBytes)
    kBigInt = hashToScalar(aHashed)
    
    # {A,X} = secrets
    # A = lG = one time public reference point 
    # klG = lB = kA = shared secret
    # key = utl.sha512Bytes(kAHex)
    # content = symetricDecrypt(X, key)
    AHex = secrets.referencePoint
    A = noble.Point.fromHex(AHex)
    kA = await A.multiply(kBigInt)
    symkeyHex = await utl.sha512Hex(kA.toHex())

    gibbrishHex = secrets.encryptedContent
    content = await encryptionmodule.symetricDecryptHex(gibbrishHex,symkeyHex)
    return content

############################################################
encryptionmodule.symetricEncryptHex = (content, keyHex) ->
    ivHex = keyHex.substring(0, 32)
    aesKeyHex = keyHex.substring(32,96)

    ivBuffer = utl.hexToBytes(ivHex)
    contentBuffer = utl.utf8ToBuffer(content)

    key = await createKeyObject(aesKeyHex)
    algorithm = 
        name: "AES-CBC"
        iv: ivBuffer

    gibbrishBuffer = await crypto.encrypt(algorithm, key, gibbrishBuffer)
    return utl.bytesToHex(gibbrishBuffer)

encryptionmodule.symetricDecryptHex = (gibbrishHex, keyHex) ->
    ivHex = keyHex.substring(0, 32)
    aesKeyHex = keyHex.substring(32,96)
    
    ivBuffer = utl.hexToBytes(ivHex)
    gibbrishBuffer = utl.hexToBytes(gibbrishHex)
    
    key = await createKeyObject(aesKeyHex)
    algorithm = 
        name: "AES-CBC"
        iv: ivBuffer
    contentBuffer = await crypto.decrypt(algorithm, key, gibbrishBuffer)
    return utl.bufferToUtf8(contentBuffer)
#endregion

module.exports = encryptionmodule