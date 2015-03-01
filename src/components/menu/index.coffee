z = require 'zorium'

styles = require './index.styl'

module.exports = class Menu
  constructor: ({selected}) ->
    styles.use()

    @state = z.state
      selected: selected
      links: [
        {
          key: 'architecture'
          text: 'Architecture'
          children: [
            {
              key: ''
              text: 'Folder Structure'
            }
            {
              key: 'components'
              text: 'Components'
            }
            {
              key: 'models'
              text: 'Models'
            }
            {
              key: 'pages'
              text: 'Pages'
            }
            {
              key: 'services'
              text: 'Services'
            }
          ]
        }
        {
          key: 'api'
          text: 'Core API'
          children: [
            {
              key: ''
              text: 'Example'
            }
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
              key: ''
              text: 'Example'
            }
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
              key: ''
              text: 'Install'
            }
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

  render: ({onNavigate}) =>
    {links, selected} = @state()

    z '.z-menu',
      z '.container',
        z.router.link \
          z 'a.logo[href=/]', 'Zorium'
        z '.break'
        z '.list',
          _.map links, (link) =>
            z '.group',
              z '.section',
                onclick: =>
                  @state.set selected: link.key
                link.text
              if selected is link.key
                _.map link.children, (child) ->
                  z "a.link[href=/#{link.key}##{child.key}]",
                    onclick: z.ev (e, $$el) ->
                      e.preventDefault()
                      onNavigate?()
                      z.router.go $$el.pathname + $$el.hash
                  , child.text
