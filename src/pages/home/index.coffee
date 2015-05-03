z = require 'zorium'
Rx = require 'rx-lite'

Head = require '../../components/head'
Menu = require '../../components/menu'
Header = require '../../components/header'
Docs = require '../../components/docs'

if window?
  require './index.styl'

module.exports = class HomePage
  constructor: ->
    @state = z.state
      $head: new Head()
      $menu: new Menu()
      $header: new Header()
      $docs: new Docs()

  renderHead: ({styles}) =>
    {$head} = @state.getValue()

    z $head, {styles}

  render: =>
    {$menu, $header, $docs} = @state.getValue()

    # FIXME: this logic should exist higher, or be managed by obseravables
    isMenuHidden = $menu.isHidden()

    z '.p-home',
      className: z.classKebab {isMenuHidden}
      z '.menu', $menu
      z '.content',
        z $header,
          title: 'Zorium'
          isHamburgerHidden: not isMenuHidden
          onHamburger: $menu.toggle
        z '.inner-padding',
          $docs
