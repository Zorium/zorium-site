z = require 'zorium'
Rx = require 'rx-lite'
HttpHash = require 'http-hash'

config = require './config'
HomePage = require './pages/home'

module.exports = class App
  constructor: ({requests, serverData, model, router}) ->
    routes = new HttpHash()

    requests = requests.map (req) ->
      route = routes.get req.path
      {req, route, $page: route.handler()}

    $homePage = new HomePage({
      model, router, serverData, requests
    })

    routes.set '/', -> $homePage
    routes.set '/:section', -> $homePage
    routes.set '/:section/:key', -> $homePage

    $backupPage = if serverData?
      routes.get(serverData.req.path).handler()
    else
      null

    @state = z.state {
      $backupPage
      request: requests
    }

  render: =>
    {request, $backupPage, $modal} = @state.getValue()

    z 'html',
      request?.$page.renderHead() or $backupPage?.renderHead()
      z 'body',
        z '#zorium-root',
          z '.z-root',
            request?.$page or $backupPage
