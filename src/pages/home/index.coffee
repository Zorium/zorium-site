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

    @state = z.state
      $head: new Head()
      $menu: new Menu()
      $header: new Header()
      $docs: new Docs()

  renderHead: ({styles}) =>
    {$head} = @state.getValue()

    z $head, {styles}

  paramsToAnchorName: ({section, key}) ->
    if key
      "#{section}_#{key}"
    else
      section

  onMount: ($$el) =>
    @scrollTargetDisposable = @scrollTargetSubject.subscribe (target) ->
      if target
        $$scrollTarget = $$el.querySelector("a[name=#{target}]")
        if document.readyState isnt 'complete'
          window.addEventListener 'load', ->
            setTimeout ->
              window.scrollTo 0, $$scrollTarget.offsetTop
        else
          window.scrollTo 0, $$scrollTarget.offsetTop

  onBeforeUnmount: =>
    @scrollTargetDisposable?.dispose()

  render: ({params}) =>
    {$menu, $header, $docs} = @state.getValue()

    scrollTarget = @paramsToAnchorName params
    if @scrollTargetSubject.getValue() isnt scrollTarget
      @scrollTargetSubject.onNext scrollTarget

    # FIXME: this logic should exist higher, or be managed by obseravables
    isMenuHidden = $menu.isHidden()

    z '.p-home',
      className: z.classKebab {isMenuHidden}
      z '.menu', $menu
      z '.content',
        z $header,
          title: 'Zorium'
          isHamburgerHidden: not isMenuHidden
          onHamburger: $menu.toggle
        z '.inner-padding',
          $docs
