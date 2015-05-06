z = require 'zorium'

util = require '../../lib/util'

if window?
  require './index.styl'

module.exports = class Md
  onMount: ($el) ->
    _.map $el.querySelectorAll('a'), (anchor) ->
      isLocal = anchor.host is window.location.host
      if isLocal
        anchor.onclick = (e) ->
          if util.isRegularClickEvent e
            e.preventDefault()
            z.server.go anchor.href

  render: ({html}) ->
    z '.z-md',
      innerHTML: html
