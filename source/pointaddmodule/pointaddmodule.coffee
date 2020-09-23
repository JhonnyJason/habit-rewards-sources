pointaddmodule = {name: "pointaddmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["pointaddmodule"]?  then console.log "[pointaddmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
pointaddmodule.initialize = () ->
    log "pointaddmodule.initialize"
    return

############################################################
#region internalFunctions
firstElementOfClass = (parent, className) ->
    return parent.getElementsByClassName(className)[0]

############################################################
#region addScoreFunctions
scorePlusX = (x, inputElement) -> 
    currentInputValue = inputElement.value
    currentInputValue = parseInt(currentInputValue) + x
    inputElement.value = currentInputValue
    return

############################################################
getScorePlus1Function = (inputElement) -> 
    return () -> scorePlusX(1, inputElement)

getScorePlus2Function = (inputElement) ->
    return () -> scorePlusX(2, inputElement)

getScorePlus5Function = (inputElement) -> 
    return () -> scorePlusX(5, inputElement)

getScorePlus10Function = (inputElement) ->
    return () ->scorePlusX(10, inputElement)
#endregion

#endregion

############################################################
#region exposedFunctions
pointaddmodule.setup = (parent) ->
    pointInput = firstElementOfClass(parent, "point-input")
    buttonPlus1 = firstElementOfClass(parent, "button-plus1")
    buttonPlus2 = firstElementOfClass(parent, "button-plus2")
    buttonPlus5 = firstElementOfClass(parent, "button-plus5")
    buttonPlus10 = firstElementOfClass(parent, "button-plus10")
    plus1 = getScorePlus1Function(pointInput)
    plus2 = getScorePlus2Function(pointInput)
    plus5 = getScorePlus5Function(pointInput)
    plus10 = getScorePlus10Function(pointInput)
    buttonPlus1.addEventListener("click", plus1)
    buttonPlus2.addEventListener("click", plus2)
    buttonPlus5.addEventListener("click", plus5)
    buttonPlus10.addEventListener("click", plus10)
    return pointInput

#endregion

module.exports = pointaddmodule