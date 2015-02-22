z = require 'zorium'
_ = require 'lodash'

Home = require '../../components/home'
Paper = require '../../components/paper'
Docs = require '../../components/docs'
Menu = require '../../components/menu'
Header = require '../../components/header'
styles = require './index.styl'

module.exports = class HomePage
  constructor: ({page}) ->
    styles.use()

    @state = z.state
      $content: switch page
        when 'api', 'router-api'
          new Docs()
        when 'paper'
          new Paper()
        else
          new Home()
      $menu: new Menu()
      $header: new Header()
      page: page

  render: =>
    {$content, $menu, $header, page} = @state()

    z '.p-home',
      z '.menu',
        z $menu, page: page
      z '.content',
        z $header, title: $menu.getTextByKey page
        z $content, page: page
