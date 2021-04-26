indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.messagebox = document.getElementById("messagebox")
    global.qrreaderBackground = document.getElementById("qrreader-background")
    global.qrreaderVideoElement = document.getElementById("qrreader-video-element")
    global.qrdisplayBackground = document.getElementById("qrdisplay-background")
    global.qrdisplayContent = document.getElementById("qrdisplay-content")
    global.qrdisplayQr = document.getElementById("qrdisplay-qr")
    global.edithabitpageContent = document.getElementById("edithabitpage-content")
    global.deleteButton = document.getElementById("delete-button")
    global.newhabitpageContent = document.getElementById("newhabitpage-content")
    global.settingspageContent = document.getElementById("settingspage-content")
    global.secretManagerInput = document.getElementById("secret-manager-input")
    global.dataManagerInput = document.getElementById("data-manager-input")
    global.accountsettings = document.getElementById("accountsettings")
    global.idDisplay = document.getElementById("id-display")
    global.idQrButton = document.getElementById("id-qr-button")
    global.addKeyButton = document.getElementById("add-key-button")
    global.deleteKeyButton = document.getElementById("delete-key-button")
    global.importKeyInput = document.getElementById("import-key-input")
    global.acceptKeyButton = document.getElementById("accept-key-button")
    global.qrScanImport = document.getElementById("qr-scan-import")
    global.floatingImport = document.getElementById("floating-import")
    global.signatureImport = document.getElementById("signature-import")
    global.copyExport = document.getElementById("copy-export")
    global.qrExport = document.getElementById("qr-export")
    global.floatingExport = document.getElementById("floating-export")
    global.signatureExport = document.getElementById("signature-export")
    global.addbutton = document.getElementById("addbutton")
    global.content = document.getElementById("content")
    global.habitviewHiddenTemplate = document.getElementById("habitview-hidden-template")
    global.habits = document.getElementById("habits")
    global.privateScoreDisplay = document.getElementById("private-score-display")
    global.headerRight = document.getElementById("header-right")
    return
    
module.exports = indexdomconnect