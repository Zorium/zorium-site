z = require 'zorium'

Md = require '../md'

api = require './api.md'
router = require './router.md'
paper = require './paper.md'
home = require './home.md'
architecture = require './architecture.md'

module.exports = class Home
  constructor: ->
    @state = z.state
      $md: new Md()

  render: ({title, page}) =>
    {$md} = @state()

    z '.z-docs',
      z $md, html: switch page
        when 'router-api'
          router
        when 'paper'
          paper
        when 'api'
          api
        when 'architecture'
          architecture
        else
          home
