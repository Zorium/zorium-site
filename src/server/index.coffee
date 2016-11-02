fs = require 'fs'
_ = require 'lodash'
z = require 'zorium'
log = require 'loga'
Rx = require 'rx-lite'
helmet = require 'helmet'
express = require 'express'
compress = require 'compression'
request = require 'clay-request'
bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'

config = require '../config'
App = require '../app'
Model = require '../models'

HSTS_GOOGLE_PRELOAD_S = 10886400 # 18 weeks
HEALTHCHECK_TIMEOUT = 200

styles = if config.ENV is config.ENVS.PROD
  fs.readFileSync 'dist/bundle.css', 'utf-8'
else
  null

bundlePath = if config.ENV is config.ENVS.PROD
  stats = JSON.parse \
    fs.readFileSync 'dist/stats.json', 'utf-8'

  "/#{stats.hash}.bundle.js"
else
  null

app = express()
app.disable 'x-powered-by'
app.use compress()
app.use cookieParser()
app.use bodyParser.json()
# Avoid CORS preflight
app.use bodyParser.json({type: 'text/plain'})
app.use bodyParser.json({type: 'application/csp-report'})
app.use helmet
  contentSecurityPolicy:
    browserSniff: false
    directives:
      scriptSrc: [
        '\'self\''
        '\'unsafe-inline\''
        '\'unsafe-eval\''
        'www.google-analytics.com'
      ].concat \
        if config.ENV is config.ENVS.DEV then [config.WEBPACK_DEV_URL] else []
      styleSrc: [
        '\'self\''
        '\'unsafe-inline\''
        'fonts.googleapis.com'
      ].concat \
        if config.ENV is config.ENVS.DEV then [config.WEBPACK_DEV_URL] else []
      reportUri: '/csp-report'
  frameguard:
    action: 'deny'
  hsts:
    # https://hstspreload.appspot.com/
    maxAge: HSTS_GOOGLE_PRELOAD_S
    includeSubDomains: true
    preload: true
    force: true
  noSniff: {}
  referrerPolicy:
    policy: 'same-origin'
  xssFilter: {}

app.get '/healthcheck', (req, res) ->
  res.status(200).json {healthy: true}
app.get '/ping', (req, res) -> res.send 'pong'
app.post '/log', (req, res) ->
  unless req.body?.event is 'client_error'
    return res.status(400).send 'must be type \'client_error\''
  log.warn req.body
  res.status(204).send()
app.post '/csp-report', (req, res) ->
  log.warn
    event: 'csp-report'
    'csp-report': req.body?['csp-report']
  res.status(204).send()

app.use '/demo', (req, res) ->
  res.json {
    id: 26881260,
    name: 'zorium',
    full_name: 'Zorium/zorium',
    private: false,
    html_url: 'https://github.com/Zorium/zorium',
    description: '(╯°□°)╯︵ ┻━┻',
    url: 'https://api.github.com/repos/Zorium/zorium',
    created_at: '2014-11-19T20:57:37Z',
    pushed_at: '2015-05-03T06:29:27Z',
    git_url: 'git://github.com/Zorium/zorium.git',
    ssh_url: 'git@github.com:Zorium/zorium.git',
    clone_url: 'https://github.com/Zorium/zorium.git',
    svn_url: 'https://github.com/Zorium/zorium',
    homepage: 'https://zorium.org/',
    language: 'CoffeeScript',
    default_branch: 'master',
  }

if config.ENV is config.ENVS.PROD
then app.use express.static('dist', {maxAge: '4h'})
else app.use express.static('build', {maxAge: '4h'})

app.use (req, res, next) ->
  setCookies = (currentCookies) ->
    (cookies) ->
      _.map cookies, (value, key) ->
        unless currentCookies[key] is value
          res.cookie(key, value, {
            path: '/'
            expires: new Date(Date.now() + config.COOKIE_DURATION_MS)
          })
      currentCookies = cookies

  cookieSubject = new Rx.BehaviorSubject req.cookies
  cookieSubject.subscribeOnNext setCookies(req.cookies)

  model = new Model({cookieSubject, serverHeaders: req.headers})
  requests = new Rx.BehaviorSubject(req)
  serverData = {req, res, styles, bundlePath}
  z.renderToString new App({requests, model, serverData})
  .then (html) ->
    res.send '<!DOCTYPE html>' + html
  .catch (err) ->
    html = err.html
    err.html = undefined
    log.error err
    if html?
      res.send '<!DOCTYPE html>' + html
    else
      next err

module.exports = app
