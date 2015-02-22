z = require 'zorium'

styles = require './index.styl'

module.exports = class Md
  constructor: ->
    styles.use()

  render: ({html}) ->
    z '.z-md',
      innerHTML: html
