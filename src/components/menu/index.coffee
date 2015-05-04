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
