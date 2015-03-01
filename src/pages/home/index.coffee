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
        when 'architecture', 'api', 'router-api'
          new Docs()
        when 'paper'
          new Paper()
        else
          new Home()
      $menu: new Menu(selected: page)
      $header: new Header()
      page: page

  render: =>
    {$content, $menu, $header, page} = @state()
    isMenuHidden = $menu.isHidden()

    z '.p-home',
      className: z.classKebab {isMenuHidden}
      z '.menu', $menu
      z '.content',
        z $header,
          title: $menu.getTextByKey page
          isHamburgerHidden: not isMenuHidden
          onHamburger: $menu.toggle
        z '.inner-padding',
          z $content, page: page
