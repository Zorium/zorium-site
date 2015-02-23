z = require 'zorium'
_ = require 'lodash'

Home = require '../../components/home'
Paper = require '../../components/paper'
Docs = require '../../components/docs'
Menu = require '../../components/menu'
Header = require '../../components/header'
styles = require './index.styl'

module.exports = class HomePage
  constructor: ({page}) ->
    styles.use()

    @state = z.state
      $content: switch page
        when 'architecture', 'api', 'router-api'
          new Docs()
        when 'paper'
          new Paper()
        else
          new Home()
      $menu: new Menu(selected: page)
      $header: new Header()
      page: page
      isMenuVisible: false

  toggleMenu: =>
    {isMenuVisible} = @state()
    @state.set isMenuVisible: not isMenuVisible

  onResize: ->
    z.redraw()

  onMount: =>
    window.addEventListener('resize', @onResize)

  onBeforeUnmount: =>
    window.removeEventListener('resize', @onResize)

  render: =>
    {$content, $menu, $header, page, isMenuVisible} = @state()
    isWide = window.matchMedia('(min-width: 1000px)').matches

    z '.p-home',
      className: z.classKebab {isMenuVisible, isWide}
      z '.overlay',
        onclick: @toggleMenu
      z '.menu',
        z $menu
      z '.content',
        z $header,
          title: $menu.getTextByKey page
          isHamburgerHidden: isWide
          onHamburger: @toggleMenu
        z '.inner-padding',
          z $content, page: page
