utilmodule = {name: "utilmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["utilmodule"]?  then console.log "[utilmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

crypto = window.crypto.subtle

############################################################
utilmodule.initialize = () ->
    log "utilmodule.initialize"
    ## testing on initialization
    # hexString = "deadbeef"
    # result = utilmodule.toBytes(hexString)
    # log result
    # hexString = utilmodule.toHex(result)
    # log hexString
    return

############################################################
byteToHex = (byte) ->
    byte = (byte & 0xFF)
    return byte.toString(16).padStart(2, '0')

############################################################
#region exposedFunctions
utilmodule.copyToClipboard = (text) ->
    log "copyToClipboard"
    ## create element to select from
    copyElement = document.createElement("textarea")
    copyElement.value = text
    copyElement.setAttribute("readonly", "")

    #have element available but not visible
    copyElement.style.position = "absolute"
    copyElement.style.left = "-99999px"
    document.body.appendChild(copyElement)
    
    #select text to copy
    document.getSelection().removeAllRanges()
    copyElement.select()
    copyElement.setSelectionRange(0, 99999)
    document.execCommand("copy")

    #remove element again
    document.body.removeChild(copyElement)
    return

############################################################
utilmodule.bytesToHex = (byteBuffer) ->
    byteArray = new Uint8Array(byteBuffer)
    return Array.prototype.map.call(byteArray, byteToHex).join("")

utilmodule.bytesToBigInt = (byteBuffer) ->
    byteArray = new Uint8Array(byteBuffer)
    value = 0n
    for byte,i in byteArray
        value += BigInt(byte) << (8n * BigInt(i))
    return value

utilmodule.hexToBytes = (hex) ->
    result = new Uint8Array(hex.length/2)
    for i in [0...hex.length] by 2
        result[(i/2)] = (parseInt(hex.substr(i, 2), 16))
    return result.buffer

utilmodule.utf8ToBuffer = (utf8) ->
    result = new Uint8Array(utf8.length)
    for i in [0...utf8.length]
        result[i] = utf8.charCodeAt(i)
    return result.buffer
    
utilmodule.bufferToUtf8 = (byteBuffer) -> 
    byteArray = new Uint8Array(byteBuffer)
    return String.fromCharCode.apply(null, byteArray)
    
############################################################
utilmodule.sha256Hex = (content) ->
    contentBytes = (new TextEncoder()).encode(content)  
    # log typeof contentBytes
    # olog contentBytes
    # return contentBytes
    hashBytes = await crypto.digest("SHA-256", contentBytes)
    return utilmodule.bytesToHex(hashBytes)

utilmodule.sha512Hex = (content) ->
    contentBytes = (new TextEncoder()).encode(content)   
    # log typeof contentBytes
    # olog contentBytes
    # return contentBytes
    hashBytes = await crypto.digest("SHA-512", contentBytes)
    return utilmodule.bytesToHex(hashBytes)

############################################################
utilmodule.sha256Bytes = (content) ->
    if (typeof content) == "string" then contentBytes = (new TextEncoder()).encode(content)
    else contentBytes = content
    
    return await crypto.digest("SHA-256", contentBytes)

utilmodule.sha512Bytes = (content) ->
    if (typeof content) == "string" then contentBytes = (new TextEncoder()).encode(content)
    else contentBytes = content

    return await crypto.digest("SHA-512", contentBytes)
    
#endregion

module.exports = utilmodule