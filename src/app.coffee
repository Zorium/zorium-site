z = require 'zorium'
paperColors = require 'zorium-paper/colors.json'
Rx = require 'rx-lite'
Routes = require 'routes'
Qs = require 'qs'

config = require './config'
HomePage = require './pages/home'
FourOhFourPage = require './pages/404'

ANIMATION_TIME_MS = 500

styles = if not window?
  # Avoid webpack include
  _fs = 'fs'
  fs = require _fs
  fs.readFileSync './dist/bundle.css', 'utf-8'
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

    $head = $currentPage.renderHead {styles}

    z 'html',
      $head
      z 'body',
        z '#zorium-root',
          className: z.classKebab {isEntering, isActive}
          z '.previous',
            $previousTree
          z '.current',
            renderPage $currentPage
