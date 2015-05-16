z = require 'zorium'
paperColors = require 'zorium-paper/colors.json'
Rx = require 'rx-lite'
Routes = require 'routes'
Qs = require 'qs'

config = require './config'
HomePage = require './pages/home'
FourOhFourPage = require './pages/404'

ANIMATION_TIME_MS = 500

# FIXME: depends on gulpfile
styles = if not window?
  # Avoid webpack include
  _fs = 'fs'
  fs = require _fs
  try
    fs.readFileSync './dist/bundle.css', 'utf-8'
  catch
    null
else
  null

# FIXME: depends on gulpfile
bundlePath = if not window?
  # Avoid webpack include
  _fs = 'fs'
  fs = require _fs
  try
    stats = JSON.parse fs.readFileSync './dist/stats.json', 'utf-8'
    "/#{stats.hash}.bundle.js"
  catch
    null
else
  null

module.exports = class RootComponent
  constructor: ->
    router = new Routes()

    $homePage = new HomePage()
    $fourOhFourPage = new FourOhFourPage()

    router.addRoute '/:section?/:key?', -> $homePage
    router.addRoute '*', -> $fourOhFourPage

    @state = z.state {
      router
      $previousTree: null
      $currentPage: null
      isEntering: false
      isActive: false
      $fourOhFourPage
    }

  render: ({req, res}) =>
    {router, $fourOhFourPage, $currentPage, $previousTree, isEntering,
     isActive} = @state.getValue()
    {path, query, state} = req

    route = router.match path

    $nextPage = route.fn()

    renderPage = ($page) ->
      z $page, {
        query
        params: route.params
        headers: req.headers
        reqState: state
      }

    if $nextPage isnt $currentPage
      $previousTree = if $currentPage then renderPage $currentPage else null
      $currentPage = $nextPage
      @state.set {
        $currentPage
        $previousTree
        isEntering: if $previousTree then true else false
      }

      if $previousTree and window?
        window.requestAnimationFrame =>
          @state.set
            isActive: true

        setTimeout =>
          @state.set
            $previousTree: null
            isEntering: false
            isActive: false
        , ANIMATION_TIME_MS

    if $currentPage is $fourOhFourPage and not window?
      res.status 404

    $head = $currentPage.renderHead {styles, bundlePath}

    z 'html',
      $head
      z 'body',
        z '#zorium-root',
          className: z.classKebab {isEntering, isActive}
          z '.previous',
            $previousTree
          z '.current',
            renderPage $currentPage
