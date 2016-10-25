z = require 'zorium'
Rx = require 'rx-lite'

config = require '../../config'
Head = require '../../components/head'
Menu = require '../../components/menu'
Header = require '../../components/header'
Docs = require '../../components/docs'

if window?
  require './index.styl'

module.exports = class HomePage
  constructor: ({model, router, serverData, requests}) ->
    @$head = new Head({
      model
      serverData
      meta:
        canonical: "https://#{config.HOST}"
    })

    @scrollTargetSubject = new Rx.BehaviorSubject(null)
    @scrollTargetDisposable = null
    @scrollToSubject = new Rx.BehaviorSubject({})

    @$menu = new Menu({router, @scrollToSubject})
    @$header = new Header()
    @$docs = new Docs({router, @scrollToSubject})

    @state = z.state
      headers: serverData?.headers
      params: requests.map (request) -> request.route.params

  renderHead: => @$head

  paramsToAnchorName: ({section, key}) ->
    if key
      "#{section}_#{key}"
    else
      section

  afterMount: ($$el) =>
    @scrollTargetDisposable = @scrollTargetSubject.subscribe (target) ->
      if target?
        $$scrollTarget = $$el.querySelector("a[name=#{target}]")
        if document.readyState isnt 'complete'
          window.addEventListener 'load', ->
            setTimeout ->
              window.scrollTo 0, $$scrollTarget.offsetTop
        else
          window.scrollTo 0, $$scrollTarget.offsetTop

  beforeUnmount: =>
    @scrollTargetDisposable?.dispose()

  render: =>
    {headers, params} = @state.getValue()

    # FIXME: this seems wrong...
    if params?
      scrollTarget = @paramsToAnchorName params
      if @scrollTargetSubject.getValue() isnt scrollTarget
        @scrollTargetSubject.onNext scrollTarget

    # FIXME: this logic should exist higher, or be managed by obseravables
    isMenuHidden = @$menu.isHidden()

    z '.p-home',
      className: z.classKebab {isMenuHidden}
      z '.menu', z @$menu, {headers}
      z '.content',
        z @$header,
          title: 'Zorium'
          isHamburgerHidden: not isMenuHidden
          onHamburger: @$menu.toggle
        z '.inner-padding',
          @$docs
