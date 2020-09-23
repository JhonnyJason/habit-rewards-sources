indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.edithabitpageContent = document.getElementById("edithabitpage-content")
    global.deleteButton = document.getElementById("delete-button")
    global.newhabitpageContent = document.getElementById("newhabitpage-content")
    global.settingspageContent = document.getElementById("settingspage-content")
    global.idDisplay = document.getElementById("id-display")
    global.secretManagerInput = document.getElementById("secret-manager-input")
    global.dataManagerInput = document.getElementById("data-manager-input")
    global.addbutton = document.getElementById("addbutton")
    global.content = document.getElementById("content")
    global.habitviewHiddenTemplate = document.getElementById("habitview-hidden-template")
    global.habits = document.getElementById("habits")
    global.privateScoreDisplay = document.getElementById("private-score-display")
    global.headerRight = document.getElementById("header-right")
    return
    
module.exports = indexdomconnect