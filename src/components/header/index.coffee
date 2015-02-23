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
    offset = window.pageYOffset
    isWide = window.matchMedia('(min-width: 760px)').matches

    @setMini(offset, isWide)
    @setFixed(offset, isWide)


  setMini: (offset, isWide) =>
    {isMini, isFixed} = @state()

    if isWide
      if offset > 116
        if not isMini
          @state.set isMini: true
      else if isMini
        @state.set isMini: false
    else
      if offset > 60
        if not isMini
          @state.set isMini: true
      else if isMini
        @state.set isMini: false

  setFixed: (offset, isWide) =>
    {isMini, isFixed} = @state()

    if isWide
      if offset > 204
        if not isFixed
          @state.set isFixed: true
      else if isFixed
        @state.set isFixed: false
    else
      if offset > 70
        if not isFixed
          @state.set isFixed: true
      else if isFixed
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
