z = require 'zorium'

Md = require '../md'
Header = require '../header'

guide = require './guide.md'
core = require './core.md'
router = require './router.md'
paper = require './paper.md'

styles = require './index.styl'

module.exports = class Home
  constructor: ->
    styles.use()

    @state = z.state
      $md: new Md()
      $header: new Header()

  render: ({title, page}) =>
    {$md, $header} = @state()

    z '.z-docs',
      z $header, title: title
      z '.body',
        z $md, html: switch page
          when 'guide'
            guide
          when 'router-api'
            router
          when 'paper'
            paper
          else
            core
