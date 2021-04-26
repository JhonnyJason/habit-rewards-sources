import Modules from "./allmodules"
import domconnect from "./indexdomconnect"
domconnect.initialize()

############################################################
global.allModules = Modules

############################################################
run = ->
    promises = (m.initialize() for n,m of Modules when m.initialize?) 
    await Promise.all(promises)
    appStartup()


############################################################
appStartup = ->
    try
        # registerServiceWorker()
        await Modules.appcoremodule.startUp()
    catch err
        errorMessage = """
            Exception in App Startup!
            So it might not work appropriately.
            
            #{err.stack}
            """
        alert errorMessage
    return

############################################################
registerServiceWorker = ->
    workerHandle = navigator.serviceWorker
    if workerHandle? then workerHandle.register('/serviceworker.js')
    return

############################################################
run()