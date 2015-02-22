z = require 'zorium'
hljs = require('highlight.js')

styles = require './index.styl'

module.exports = class Code
  constructor: ->
    styles.use()

  render: ({code}) ->
    z 'pre.z-code',
      innerHTML: hljs.highlight('coffeescript', code).value
