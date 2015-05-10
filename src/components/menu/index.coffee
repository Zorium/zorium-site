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
            { key: 'features', text: 'Features' }
            { key: 'example', text: 'Example' }
            { key: 'installation', text: 'Installation' }
            { key: 'contribute', text: 'Contribute' }
          ]
        }
        {
          select: 'tutorial'
          text: 'Tutorial'
          children: [
            { key: 'first-component', text: 'First Component' }
            { key: 'stateful-components', text: 'Stateful Components' }
            { key: 'composing-components', text: 'Composing Components' }
            { key: 'streams', text: 'Streams' }
            { key: 'server-side-rendering', text: 'Server Side Rendering' }
          ]
        }
        {
          select: 'api'
          text: 'Core API'
          children: [
            { key: 'z', text: 'z()' }
            { key: 'components', text: 'Components'}
            { key: 'render', text: 'z.render()'}
            { key: 'render-to-string', text: 'z.renderToString()'}
            { key: 'state', text: 'z.state()'}
            { key: 'ev', text: 'z.ev()'}
            { key: 'class-kebab', text: 'z.classKebab()'}
            { key: 'is-simple-click', text: 'z.isSimpleClick()'}
          ]
        }
        {
          select: 'router'
          text: 'Router API'
          children: [
            { key: 'link', text: 'z.router.link()' }
            { key: 'init', text: 'z.router.init()' }
            { key: 'go', text: 'z.router.go()' }
            { key: 'full-page-rendering', text: 'Full Page Rendering' }
            { key: 'use', text: 'z.router.use()' }
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

  isMobile: (userAgent) ->
    ///
      Mobile
    | iP(hone|od|ad)
    | Android
    | BlackBerry
    | IEMobile
    | Kindle
    | NetFront
    | Silk-Accelerated
    | (hpw|web)OS
    | Fennec
    | Minimo
    | Opera\ M(obi|ini)
    | Blazer
    | Dolfin
    | Dolphin
    | Skyfire
    | Zune
    ///.test userAgent

  isPermanent: ->
    if window?
      window.matchMedia('(min-width: 1000px)').matches
    else
      false
      # FIXME
      #not @isMobile z.router.getReq().headers?['user-agent']

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
          z 'a.logo',
            href: '/'
            onclick: z.ev (e, $$el) =>
              if z.isSimpleClick e
                e.preventDefault()
                # Manually scroll because we don't want people to lose
                # their scoll position on page refresh
                window.scrollTo(0, 0)
                unless isPermanent
                  @toggle()
                z.router.go $$el.href
            'Zorium'
          z '.break'
          z '.list',
            _.map links, (link) =>
              isSelected = selected is link.select
              z '.group',
                className: z.classKebab {isSelected}
                z 'a.section',
                  href: "/#{link.select}"
                  onclick: z.ev (e, $$el) =>
                    if z.isSimpleClick e
                      e.preventDefault()
                      if isSelected
                        unless isPermanent
                          @toggle()
                        z.router.go $$el.href
                      else
                        @state.set selected: link.select

                  link.text
                _.map link.children, (child) =>
                  z 'a.link',
                    href: "/#{link.select}/#{child.key}"
                    onclick: z.ev (e, $$el) =>
                      if z.isSimpleClick e
                        e.preventDefault()
                        unless isPermanent
                          @toggle()
                        z.router.go $$el.href
                  , child.text
        z '.padder'
