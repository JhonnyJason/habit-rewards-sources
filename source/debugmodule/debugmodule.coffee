debugmodule = {name: "debugmodule", uimodule: false}

#####################################################
debugmodule.initialize = () ->
    # console.log "debugmodule.initialize - nothing to do"
    return

#####################################################
debugmodule.modulesToDebug =
    unbreaker: true
    # authmodule: true
    # configmodule: true
    # habitsmodule: true
    # edithabitpagemodule: true
    # encryptionmodule: true
    # networkmodule: true
    scoremodule: true
    # secretsmodule: true
    # slideinframemodule: true
    # settingspagemodule: true
    # statemodule: true
    # utilmodule: true

export default debugmodule
