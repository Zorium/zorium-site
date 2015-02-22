z = require 'zorium'

styles = require './index.styl'

module.exports = class Menu
  constructor: ->
    styles.use()

  render: ->
    z '.z-menu',
      z '.overlay'
      z '.container',
        z '.logo', 'Zorium'
        z '.break'
        z '.list',
          z '.category',
            'Home'
          z '.category',
            'Guide'
            z '.link', 'Getting Started'
          z '.category',
            'API'
            z '.link', 'z()'
            z '.link', 'z.state()'
          z '.category',
            'Paper'
