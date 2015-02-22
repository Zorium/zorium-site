z = require 'zorium'
_ = require 'lodash'

Home = require '../../components/home'
Menu = require '../../components/menu'
styles = require './index.styl'

module.exports = class HomePage
  constructor: ->
    styles.use()

    @state = z.state
      $home: new Home()
      $menu: new Menu()

  render: =>
    {$home, $menu} = @state()

    z '.p-home',
      z '.menu', $menu
      z '.home', $home
