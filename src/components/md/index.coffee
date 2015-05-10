z = require 'zorium'

if window?
  require './index.styl'

module.exports = class Md
  onMount: ($el) ->
    _.map $el.querySelectorAll('a'), (anchor) ->
      isLocal = anchor.host is window.location.host
      if isLocal
        anchor.onclick = (e) ->
          if z.isSimpleClick e
            e.preventDefault()
            z.router.go anchor.href

  render: ({html}) ->
    z '.z-md',
      innerHTML: html
