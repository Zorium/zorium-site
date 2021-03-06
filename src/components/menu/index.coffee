z = require 'zorium'
_ = require 'lodash'

if window?
  require './index.styl'

module.exports = class Menu
  constructor: ({@router, @scrollToSubject}) ->
    @state = z.state
      scrollTo: @scrollToSubject
      isHidden: not @isPermanent()
      links: [
        {
          select: 'intro'
          text: 'Intro'
          children: [
            {key: 'example', text: 'Example'}
            {key: 'features', text: 'Features'}
            {key: 'installation', text: 'Installation'}
            {key: 'contribute', text: 'Contribute'}
          ]
        }
        {
          select: 'tutorial'
          text: 'Tutorial'
          children: [
            {key: 'first-component', text: 'First Component'}
            {key: 'stateful-components', text: 'Stateful Components'}
            {key: 'composing-components', text: 'Composing Components'}
            {key: 'streams', text: 'Streams'}
            {key: 'server-side-rendering', text: 'Server Side Rendering'}
          ]
        }
        {
          select: 'api'
          text: 'Core API'
          children: [
            {key: 'z', text: 'z()'}
            {key: 'components', text: 'Components'}
            {key: 'state', text: 'z.state()'}
            {key: 'render', text: 'z.render()'}
            {key: 'render-to-string', text: 'z.renderToString()'}
            {key: 'bind', text: 'z.bind()'}
            {key: 'until-stable', text: 'z.untilStable()'}
            {key: 'ev', text: 'z.ev()'}
            {key: 'class-kebab', text: 'z.classKebab()'}
            {key: 'is-simple-click', text: 'z.isSimpleClick()'}
          ]
        }
        {
          select: 'best-practices'
          text: 'Best Practices'
          children: [
            {key: 'zorium-seed', text: 'Zorium Seed'}
            {key: 'coffee-script', text: 'CoffeeScript'}
            {key: 'webpack', text: 'Webpack'}
            {key: 'naming', text: 'Naming'}
            {key: 'stylus', text: 'Stylus'}
            {key: 'state-management', text: 'State Management'}
            {
              key: 'server-side-considerations'
              text: 'Server-Side Considerations'
            }
            {key: 'animation', text: 'Animation'}
          ]
        }
        {
          select: 'paper'
          text: 'Zorium Paper'
          children: [
            {key: 'shadows', text: 'Shadows'}
            {key: 'fonts', text: 'Fonts'}
            {key: 'colors', text: 'Colors'}
            {key: 'button', text: 'Button'}
            {key: 'checkbox', text: 'Checkbox'}
            {key: 'input', text: 'Input'}
            {key: 'radio-button', text: 'Radio Button'}
          ]
        }
      ]

  afterMount: =>
    window.addEventListener 'resize', @onResize

  beforeUnmount: =>
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

  isPermanent: (headers) =>
    if window?
      window.matchMedia('(min-width: 1000px)').matches
    else if headers
      not @isMobile headers['user-agent']
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

  render: ({headers}) =>
    {links, scrollTo, isHidden} = @state.getValue()
    isPermanent = @isPermanent(headers)

    selected = scrollTo?.section or 'intro'
    selectedKey = scrollTo?.key

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
                @router.go $$el.href
            'Zorium'
          z '.break'
          z '.list',
            _.map links, (link) =>
              isSelected = link.select is selected
              z '.group',
                className: z.classKebab {isSelected}
                z 'a.section',
                  className: z.classKebab
                    isSelected: isSelected and not selectedKey?
                  href: "/#{link.select}"
                  onclick: z.ev (e, $$el) =>
                    if z.isSimpleClick e
                      e.preventDefault()
                      if isSelected
                        unless isPermanent
                          @toggle()
                        @router.go $$el.href
                      else
                        @scrollToSubject.onNext {section: link.select}

                  link.text
                _.map link.children, (child) =>
                  z 'a.link',
                    className: z.classKebab
                      isSelected: child.key is selectedKey
                    href: "/#{link.select}/#{child.key}"
                    onclick: z.ev (e, $$el) =>
                      if z.isSimpleClick e
                        e.preventDefault()
                        unless isPermanent
                          @toggle()
                        @router.go $$el.href
                  , child.text
        z '.padder'
