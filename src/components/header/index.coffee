z = require 'zorium'

styles = require './index.styl'

module.exports = class Header
  constructor: ->
    styles.use()

    @state = z.state
      isMini: false

  onScroll: =>
    {isMini} = @state()
    if window.pageYOffset > 100 and not isMini
      @state.set isMini: true
    else if window.pageYOffset < 100 and isMini
      @state.set isMini: false

  onMount: =>
    document.addEventListener 'scroll', @onScroll

  onBeforeUnmount: =>
    document.removeEventListener 'scroll', @onScroll

  render: ({title}) =>
    {isMini} = @state()

    z '.z-header',
      className: z.classKebab {isMini}
      z '.stub'
      z '.header',
        z '.title', title
