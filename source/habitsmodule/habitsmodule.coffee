habitsmodule = {name: "habitsmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["habitsmodule"]?  then console.log "[habitsmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
mustache = require "mustache"

############################################################
state = null
scoreModule = null
editPage = null

############################################################
touchTimeoutMS = 1000
habitHTMLTemplate = ""
defaultContentHTML = ""

############################################################
touchedHabit = null
touchTimerId = null

############################################################
habitsmodule.initialize = () ->
    log "habitsmodule.initialize"
    state = allModules.statemodule
    editPage = allModules.edithabitpagemodule
    scoreModule = allModules.scoremodule
    
    habitHTMLTemplate = habitviewHiddenTemplate.innerHTML
    defaultContentHTML = habits.innerHTML

    syncHabitsFromState()
    state.addOnChangeListener("habitIds", syncHabitsFromState)

    ## disable dragging
    habits.ondragover = (event) -> event.preventDefault()
    return

############################################################
#region internalFunctions
syncHabitsFromState = ->
    log "syncHabitsFromState"
    allIds = state.load("habitIds")
    
    if !allIds? or allIds.length == 0
        habits.innerHTML = defaultContentHTML
        return

    habitsContentHTML = ""

    for id in allIds when habitObject = state.load(id)
        habitsContentHTML += createHabitHTML(habitObject)

    # olog habitsContentHTML
    habits.innerHTML = habitsContentHTML
    
    attachFunctionsToHabits()
    return

############################################################
createHabitHTML = (habitObject) -> mustache.render(habitHTMLTemplate,habitObject)

createHabitUpdateFunction = (habitId, viewElement) ->
    return () ->
        habitObject = state.load(habitId)
        habitText = viewElement.getElementsByClassName("habit-text")[0]
        habitText.textContent = habitObject.habitText
        return

############################################################
attachFunctionsToHabits = ->
    log "attachFunctionsToHabits"
    allHabits = habits.getElementsByClassName("habit")

    for habit in allHabits
        habit.addEventListener("click", habitClicked)
        habit.addEventListener("touchstart", habitTouchStarted)
        habit.addEventListener("touchend", habitTouchEnded)
        
        habit.addEventListener("mousedown", habitTouchStarted)
        habit.addEventListener("mouseup", habitTouchEnded)
        habit.addEventListener("mouseleave", habitTouchEnded)

        id = habit.getAttribute("habit-id")
        updateFunction = createHabitUpdateFunction(id, habit)
        state.addOnChangeListener(id, updateFunction)
    return

############################################################
editActivated = ->
    log "editActivated"
    editPage.startEdit(touchedHabit)
    habitTouchEnded()
    return

############################################################
habitClicked = (event) ->
    log "habitClicked"
    id = event.target.getAttribute("habit-id")
    habitObject = state.load(id)
    olog habitObject
    score = habitObject.scoreToAdd
    olog scoreModule
    scoreModule.addScore(score)
    return 

habitTouchStarted = ->
    log "habitTouchStarted"
    if touchTimerId then clearTimeout(touchTimerId)
    touchedHabit = event.target.getAttribute("habit-id")
    touchTimerId = setTimeout(editActivated, touchTimeoutMS)
    return

habitTouchEnded = ->
    log "habitTouchEnded"
    if touchTimerId then clearTimeout(touchTimerId)
    touchedHabit = null
    touchTimerId = null
    return

#endregion

############################################################
#region exposedFunctions
habitsmodule.getTextEdit = (parent) ->
    return parent.getElementsByClassName("habit-text-edit")[0]

habitsmodule.addNewHabit = (habitText, scoreToAdd) ->
    id = state.load("nextHabitId") || "" + 0
    allIds = state.load("habitIds")
    
    if allIds? then allIds = [allIds...]
    else allIds = []
    allIds.push id
    

    number = parseInt(id)
    number++
    nextHabitId = "" + number 

    newHabitObject = {id, habitText, scoreToAdd}

    state.save("nextHabitId", nextHabitId)
    state.save(id, newHabitObject)
    state.save("habitIds", allIds)
    return

#endregion

module.exports = habitsmodule