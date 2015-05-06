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
          select: 'api'
          text: 'Core API'
          children: [
            { key: 'z', text: 'z()' }
            { key: 'components', text: 'Components'}
            { key: 'render', text: 'z.render()'}
            { key: 'state', text: 'z.state()'}
            { key: 'cookies-set', text: 'z.cookies.set()'}
            { key: 'cookies-get', text: 'z.cookies.get()'}
            { key: 'ev', text: 'z.ev()'}
            { key: 'class-kebab', text: 'z.classKebab'}
          ]
        }
        {
          select: 'server'
          text: 'Server API'
          children: [
            { key: 'link', text: 'z.server.link()' }
            { key: 'set', text: 'z.server.set()' }
            { key: 'go', text: 'z.server.go()' }
            { key: 'on', text: 'z.server.on()' }
            { key: 'off', text: 'z.server.off()' }
            { key: 'redirect', text: 'z.server.Redirect' }
            { key: 'set-status', text: 'z.server.setStatus()' }
            { key: 'full-page-rendering', text: 'Full Page Rendering' }
            {
              key: 'factory-to-middleware',
              text: 'z.server.factoryToMiddleware()'
            }
          ]
        }
        {
          select: 'best-practices'
          text: 'Best Practices'
          children: [
            { key: 'zorium-seed', text: 'Zorium Seed' }
            { key: 'stylus', text: 'Stylus' }
            { key: 'coffee-script', text: 'CoffeeScript' }
            { key: 'state-management', text: 'State Management' }
            { key: 'animation', text: 'Animation' }
            { key: 'naming', text: 'Naming' }
          ]
        }
        {
          select: 'paper'
          text: 'Zorium Paper'
          children: [
            { key: 'shadows', text: 'Shadows' }
            { key: 'fonts', text: 'Fonts' }
            { key: 'colors', text: 'Colors' }
            { key: 'button', text: 'Button' }
            { key: 'checkbox', text: 'Checkbox' }
            { key: 'dialog', text: 'Dialog' }
            { key: 'floating-action-button', text: 'Floating Action Button' }
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
              isSelected = selected is link.select
              z '.group',
                className: z.classKebab {isSelected}
                z 'a.section',
                  href: "/#{link.select}"
                  onclick: z.ev (e, $$el) =>
                    e.preventDefault()
                    if e.which is 2 # middle click
                      window.open $$el.href
                    else
                      if isSelected
                        z.server.go $$el.href
                      else
                        @state.set selected: link.select
                  link.text
                _.map link.children, (child) =>
                  z 'a.link',
                    href: "/#{link.select}/#{child.key}"
                    onclick: z.ev (e, $$el) =>
                      e.preventDefault()
                      unless isPermanent
                        @toggle()
                      if e.which is 2 # middle click
                        window.open $$el.href
                      else
                        z.server.go $$el.href
                  , child.text
        z '.padder'
