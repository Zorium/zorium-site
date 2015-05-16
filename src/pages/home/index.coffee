z = require 'zorium'
Rx = require 'rx-lite'

Head = require '../../components/head'
Menu = require '../../components/menu'
Header = require '../../components/header'
Docs = require '../../components/docs'

if window?
  require './index.styl'

module.exports = class HomePage
  constructor: ->
    @scrollTargetSubject = new Rx.BehaviorSubject(null)
    @scrollTargetDisposable = null
    @shouldSkipScroll = new Rx.BehaviorSubject(false)
    @scrollToSubject = new Rx.BehaviorSubject({})

    @state = z.state
      $head: new Head()
      $menu: new Menu({@scrollToSubject})
      $header: new Header()
      $docs: new Docs({@scrollToSubject})

  renderHead: (params) =>
    {$head} = @state.getValue()

    z $head, params

  paramsToAnchorName: ({section, key}) ->
    if key
      "#{section}_#{key}"
    else
      section

  onMount: ($$el) =>
    @scrollTargetDisposable = @scrollTargetSubject.subscribe (target) =>
      if target and not @shouldSkipScroll.getValue()
        $$scrollTarget = $$el.querySelector("a[name=#{target}]")
        if document.readyState isnt 'complete'
          window.addEventListener 'load', ->
            setTimeout ->
              window.scrollTo 0, $$scrollTarget.offsetTop
        else
          window.scrollTo 0, $$scrollTarget.offsetTop

  onBeforeUnmount: =>
    @scrollTargetDisposable?.dispose()

  render: ({params, headers, reqState}) =>
    {$menu, $header, $docs} = @state.getValue()

    scrollTarget = @paramsToAnchorName params
    if @scrollTargetSubject.getValue() isnt scrollTarget
      @shouldSkipScroll.onNext reqState?.shouldSkipScroll or false
      @scrollTargetSubject.onNext scrollTarget

    # FIXME: this logic should exist higher, or be managed by obseravables
    isMenuHidden = $menu.isHidden()

    z '.p-home',
      className: z.classKebab {isMenuHidden}
      z '.menu', z $menu, {headers}
      z '.content',
        z $header,
          title: 'Zorium'
          isHamburgerHidden: not isMenuHidden
          onHamburger: $menu.toggle
        z '.inner-padding',
          $docs
