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
    {isMini, isFixed} = @state()
    isWide = window.matchMedia('(min-width: 760px)').matches

    console.log window.pageYOffset
    if isWide
      if window.pageYOffset > 116 and not isMini
        @state.set isMini: true
      else if window.pageYOffset < 116 and isMini
        @state.set isMini: false

      if window.pageYOffset > 204 and not isFixed
        @state.set isFixed: true
      else if window.pageYOffset < 204 and isFixed
        @state.set isFixed: false
    else
      if window.pageYOffset > 60 and not isMini
        @state.set isMini: true
      else if window.pageYOffset < 60 and isMini
        @state.set isMini: false

      if window.pageYOffset > 70 and not isFixed
        @state.set isFixed: true
      else if window.pageYOffset < 70 and isFixed
        @state.set isFixed: false

  onMount: =>
    document.addEventListener 'scroll', @onScroll
    @onScroll()

  onBeforeUnmount: =>
    document.removeEventListener 'scroll', @onScroll

  render: ({title, onHamburger, isHamburgerHidden}) =>
    {isMini, isFixed, $hamburger} = @state()

    z '.z-header',
      className: z.classKebab {isMini, isHamburgerHidden, isFixed}
      z '.stub'
      z '.header',
        z '.hamburger',
          onclick: onHamburger
          z $hamburger,
            icon: 'menu'
            isDark: true
        z '.title', title
