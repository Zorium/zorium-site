z = require 'zorium'

if window?
  require './index.styl'

module.exports = class Md
  render: ({html}) ->
    z '.z-md',
      innerHTML: html
