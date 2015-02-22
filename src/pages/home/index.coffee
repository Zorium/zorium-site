z = require 'zorium'
_ = require 'lodash'

Home = require '../../components/home'
Docs = require '../../components/docs'
Menu = require '../../components/menu'
styles = require './index.styl'

module.exports = class HomePage
  constructor: ({page}) ->
    styles.use()

    @state = z.state
      $content: switch page
        when 'guide', 'api', 'router-api', 'paper'
          new Docs()
        else
          new Home()
      $menu: new Menu()
      page: page

  render: =>
    {$content, $menu, page} = @state()

    z '.p-home',
      z '.menu',
        z $menu
      z '.home',
        z $content,
          title: $menu.getTextByKey page
          page: page
