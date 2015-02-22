z = require 'zorium'

PrimaryButton = require '../primary_button'
SecondaryButton = require '../secondary_button'
Docs = require '../docs'

styles = require './index.styl'

module.exports = class Home
  constructor: ->
    styles.use()

    @state = z.state
      $docs: new Docs()
      $downloadBtn: new PrimaryButton()
      $downloadSeedBtn: new SecondaryButton()

  render: =>
    {$docs, $downloadBtn, $downloadSeedBtn} = @state()

    z '.z-home',
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
      z $docs, page: 'home'
