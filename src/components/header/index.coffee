z = require 'zorium'
Icon = require 'zorium-paper/icon'

styles = require './index.styl'

module.exports = class Header
  constructor: ->
    styles.use()

    @state = z.state
      isMini: false
      $hamburger: new Icon()

  onScroll: =>
    {isMini} = @state()
    if window.pageYOffset > 116 and not isMini
      @state.set isMini: true
    else if window.pageYOffset < 116 and isMini
      @state.set isMini: false

  onMount: =>
    document.addEventListener 'scroll', @onScroll

  onBeforeUnmount: =>
    document.removeEventListener 'scroll', @onScroll

  render: ({title, onHamburger, isHamburgerHidden}) =>
    {isMini, $hamburger} = @state()

    z '.z-header',
      className: z.classKebab {isMini, isHamburgerHidden}
      z '.stub'
      z '.header',
        z '.hamburger',
          onclick: onHamburger
          z $hamburger,
            icon: 'menu'
            isDark: true
        z '.title', title
