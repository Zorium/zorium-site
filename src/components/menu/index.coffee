z = require 'zorium'
_ = require 'lodash'

if window?
  require './index.styl'

module.exports = class Menu
  constructor: ->
    @state = z.state
      selected: 'api'
      isHidden: not @isPermanent()
      links: [
        {
          select: 'intro'
          text: 'Intro'
          children: [
            { key: 'simple', text: 'A Simple Component' }
            { key: 'stateful', text: 'A Stateful Component' }
            { key: 'application', text: 'An Application' }
          ]
        }
        {
          select: 'architecture'
          text: 'Architecture'
          children: [
            { key: '', text: 'Folder Structure' }
            { key: 'components', text: 'Components' }
            { key: 'models', text: 'Models' }
            { key: 'pages', text: 'Pages' }
            { key: 'services', text: 'Services' }
          ]
        }
        {
          select: 'api'
          text: 'Core API'
          children: [
            { key: '', text: 'Example' }
            { key: 'z', text: 'z()' }
            { key: 'render', text: 'z.render()' }
            { key: 'redraw', text: 'z.redraw()' }
            { key: 'state', text: 'z.state()' }
            { key: 'observe', text: 'z.observe()' }
            { key: 'ev', text: 'z.ev()' }
          ]
        }
        {
          select: 'router'
          text: 'Router API'
          children: [
            { key: '', text: 'Example' }
            { key: 'set-mode', text: 'z.router.setMode()' }
            { key: 'set-root', text: 'z.router.setRoot()' }
            { key: 'add', text: 'z.router.add()' }
            { key: 'go', text: 'z.router.go()' }
            { key: 'link', text: 'z.router.link()' }
            { key: 'current-path', text: 'z.router.currentPath' }
            { key: 'on', text: 'z.router.on()' }
          ]
        }
        {
          select: 'paper'
          text: 'Paper'
          children: [
            { key: '', text: 'Install' }
            { key: 'shadows', text: 'Shadows' }
            { key: 'fonts', text: 'Fonts' }
            { key: 'colors', text: 'Colors' }
            { key: 'button', text: 'Button' }
            { key: 'checkbox', text: 'Checkbox' }
            { key: 'dialog', text: 'Dialog' }
            { key: 'floating-action-button', text: 'Floating Action' }
            { key: 'input', text: 'Input' }
            { key: 'radio-button', text: 'Radio Button' }
          ]
        }
      ]

  onMount: =>
    window.addEventListener 'resize', @onResize

  onBeforeUnmount: =>
    window.removeEventListener 'resize', @onResize

  onResize: =>
    @state.set isHidden: not @isPermanent()

  isPermanent: ->
    if window?
      window.matchMedia('(min-width: 1000px)').matches
    else
      false

  isHidden: =>
    @state.getValue().isHidden

  toggle: =>
    {isHidden} = @state.getValue()
    isHidden = not isHidden

    # prevent body scrolling while viewing menu
    if isHidden
      document.body.style.overflow = 'auto'
    else
      document.body.style.overflow = 'hidden'

    @state.set isHidden: isHidden

  getTextByKey: (key) =>
    {links} = @state.getValue()
    return _.find(links, {key})?.text or 'Zorium'

  render: =>
    {links, selected, isHidden} = @state.getValue()
    isPermanent = @isPermanent()

    z '.z-menu',
      className: z.classKebab {
        isHidden: isHidden and not isPermanent
        isPermanent
      }
      z '.stub'
      z '.overlay',
        onclick: @toggle
      z '.container',
        z '.menu',
          z.server.link \
            z 'a.logo[href=/]', 'Zorium'
          z '.break'
          z '.list',
            _.map links, (link) =>
              z '.group',
                className: z.classKebab {isSelected: selected is link.select}
                z '.section',
                  onclick: =>
                    @state.set selected: link.select
                  link.text
                _.map link.children, (child) =>
                  z 'a.link',
                    href: "/#{link.select}/#{child.key}"
                    onclick: z.ev (e, $$el) =>
                      e.preventDefault()
                      unless isPermanent
                        @toggle()
                      z.server.go $$el.href
                  , child.text
        z '.padder'
