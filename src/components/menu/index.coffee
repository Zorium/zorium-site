z = require 'zorium'

styles = require './index.styl'

module.exports = class Menu
  constructor: ->
    styles.use()

    @state = z.state
      links: [
        {
          key: ''
          text: 'Home'
          children: []
        }
        {
          key: 'api'
          text: 'Core API'
          children: [
            {
              key: 'z'
              text: 'z()'
            }
            {
              key: 'render'
              text: 'z.render()'
            }
            {
              key: 'redraw'
              text: 'z.redraw()'
            }
            {
              key: 'state'
              text: 'z.state()'
            }
            {
              key: 'observe'
              text: 'z.observe()'
            }
            {
              key: 'ev'
              text: 'z.ev()'
            }
          ]
        }
        {
          key: 'router-api'
          text: 'Router API'
          children: [
            {
              key: 'set-mode'
              text: 'z.router.setMode()'
            }
            {
              key: 'set-root'
              text: 'z.router.setRoot()'
            }
            {
              key: 'add'
              text: 'z.router.add()'
            }
            {
              key: 'go'
              text: 'z.router.go()'
            }
            {
              key: 'link'
              text: 'z.router.link()'
            }
            {
              key: 'current-path'
              text: 'z.router.currentPath'
            }
            {
              key: 'on'
              text: 'z.router.on()'
            }
          ]
        }
        {
          key: 'paper'
          text: 'Paper'
          children: [
            {
              key: 'shadows'
              text: 'Shadows'
            }
            {
              key: 'fonts'
              text: 'Fonts'
            }
            {
              key: 'colors'
              text: 'Colors'
            }
            {
              key: 'button'
              text: 'Button'
            }
            {
              key: 'checkbox'
              text: 'Checkbox'
            }
            {
              key: 'dialog'
              text: 'Dialog'
            }
            {
              key: 'floating-action-button'
              text: 'Floating Action'
            }
            {
              key: 'input'
              text: 'Input'
            }
            {
              key: 'radio-button'
              text: 'Radio Button'
            }
          ]
        }
      ]

  getTextByKey: (key) =>
    {links} = @state()

    return _.find(links, {key})?.text or 'Zorium'

  render: ({page}) =>
    {links} = @state()

    z '.z-menu',
      z '.container',
        z '.logo', 'Zorium'
        z '.break'
        z '.list',
          _.map links, (link) ->
            z '.group',
              z.router.link \
                z "a.section[href=/#{link.key}]",
                  link.text
              if page is link.key or link.key is 'api'
                _.map link.children, (child) ->
                  z.router.link \
                    z "a.link[href=/#{link.key}##{child.key}]", child.text
