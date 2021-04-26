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

############################################################
tbu = require("thingy-byte-utils")
Object.assign(utilmodule, tbu)

msgBox = require("./messageboxmodule")

############################################################
utilmodule.initialize = () ->
    log "utilmodule.initialize"
    return

############################################################
#region exposedFunctions
utilmodule.add0x = (hex) ->
    if !hex? then throw new Error("add0x - undefined argument!")
    return hex unless hex[0] != "0" or hex[1] != "x"
    return "0x"+hex

utilmodule.strip0x = (hex) ->
    if !hex? then throw new Error("strip0x - undefined argument!")
    return hex unless hex[0] == "0" and hex[1] == "x"
    return hex.slice(2)

############################################################
utilmodule.seedToKey = (seed) ->
    hashHex = await secUtl.sha512Hex(seed)
    shift = parseInt(hashHex[0], 16) * 2
    return hashHex.substr(shift, 64)

############################################################
utilmodule.isValidKey = (key) ->
    return unless key?
    key = utilmodule.strip0x(key)
    return false unless key.length == 64
    for c in key when parseInt(c,16) == NaN then return false
    return true


############################################################
utilmodule.copyToClipboard = (text) ->
    try 
        await navigator.clipboard.writeText(text)
        log "Clipboard API succeeded"
        if msgBox? then msgBox.info("Copied: "+text)
        return
    catch err then log err

    ## Oldschool Method
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
    if msgBox? then msgBox.info("Copied: "+text)
    return
        
#endregion

module.exports = utilmodule