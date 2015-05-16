require './polyfill'

_ = require 'lodash'
z = require 'zorium'
log = require 'clay-loglevel'

require './root.styl'
config = require './config'
ErrorReportService = require './services/error_report'
App = require './app'

###########
# LOGGING #
###########

# Configure ErrorReportService before usage
# window.addEventListener 'error', ErrorReportService.report

if config.ENV isnt config.ENVS.PROD
  log.enableAll()
else
  log.setLevel 'error'
  log.on 'error', ErrorReportService.report
  log.on 'trace', ErrorReportService.report


#################
# ROUTING SETUP #
#################

$$root = document.getElementById 'zorium-root'

init = ->
  z.router.init
    $$root: $$root

  $app = new App()
  z.router.use (req, res) ->
    res.send z $app, {req, res}
  z.router.go()

if document.readyState isnt 'complete' and not $$root
  window.addEventListener 'load', init
else
  init()

#############################
# ENABLE WEBPACK HOT RELOAD #
#############################

if module.hot
  module.hot.accept()
