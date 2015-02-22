z = require 'zorium'

Md = require '../md'
PrimaryButton = require '../primary_button'
SecondaryButton = require '../secondary_button'
Header = require '../header'
pageMd = require './index.md'

styles = require './index.styl'

module.exports = class Home
  constructor: ->
    styles.use()

    @state = z.state
      $md: new Md()
      $header: new Header()
      $downloadBtn: new PrimaryButton()
      $downloadSeedBtn: new SecondaryButton()

  render: =>
    {$md, $header, $downloadBtn, $downloadSeedBtn} = @state()

    z '.z-home',
      z $header, title: 'Zorium'
      z '.body',
        z '.title', 'Introduction'
        z '.content',
          z '.text',
            'Zorium is a CoffeeScript Web Framework. '
            'It uses '
            z 'a.a[href=https://github.com/webpack/webpack]', 'WebPack'
            ' and '
            z 'a.a[href=https://github.com/Matt-Esch/virtual-dom]',
              'Virtual-DOM'
            ' to provide component isolation and efficient rendering.'
            ' No magic, no JSX, no bullshit,
              just plain CoffeeScript'
            z '.buttons',
              z 'a[href=https://github.com/Zorium/zorium]',
                z $downloadBtn, text: 'github'
              z 'a[href=https://github.com/Zorium/zorium-seed]',
                z $downloadSeedBtn, text: 'seed'
        z $md, html: pageMd
