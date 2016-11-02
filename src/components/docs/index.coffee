z = require 'zorium'
_ = require 'lodash'
Rx = require 'rx-lite'
paperColors = require 'zorium-paper/colors.json'
Button = require 'zorium-paper/button'
Checkbox = require 'zorium-paper/checkbox'
Input = require 'zorium-paper/input'
Radio = require 'zorium-paper/radio_button'

Md = require '../md'
Tutorial = require '../tutorial'
MarkdownService = require '../../services/markdown'

if window?
  intro = require './intro.md'
  api = require './api.md'
  bestPractices = require './best_practices.md'
  paper = require './paper.md'
else
  # Avoid webpack include
  _fs = 'fs'
  fs = require _fs

  intro = MarkdownService.marked \
    fs.readFileSync __dirname + '/intro.md', 'utf-8'
  api = MarkdownService.marked \
    fs.readFileSync __dirname + '/api.md', 'utf-8'
  bestPractices = MarkdownService.marked \
    fs.readFileSync __dirname + '/best_practices.md', 'utf-8'
  paper = MarkdownService.marked \
    fs.readFileSync __dirname + '/paper.md', 'utf-8'

if window?
  require './index.styl'

fonts = [
  'display4'
  'display3'
  'display2'
  'display1'
  'headline'
  'title'
  'subhead'
  'body2'
  'body1'
  'caption'
  'button'
]

isNodeVisible = ($el) ->
  bounds = $el.getBoundingClientRect()
  # 20 px buffer, prevents off-by-one scrolling to next anchor
  bounds.top >= -20 and bounds.bottom <= window.innerHeight

module.exports = class Docs
  constructor: ({@router, @scrollToSubject}) ->
    @state = z.state
      $md1: new Md()
      $md2: new Md()
      $tutorial: new Tutorial()
      $getStartedBtn: new Button
        isRaised: true
        color: 'teal'
      $downloadBtn: new Button()
      $downloadSeedBtn: new Button()
      $buttons: [
        new Button()
        new Button({color: 'red'})
        new Button({isDisabled: true})
        new Button({isRaised: true})
        new Button({isRaised: true, color: 'blue'})
        new Button({isRaised: true, isDisabled: true, color: 'green'})
      ]
      checkboxes:
        $checked: [
          new Checkbox({isChecked: new Rx.BehaviorSubject(true), color: 'blue'})
          new Checkbox({
            isChecked: new Rx.BehaviorSubject(true)
            isDisabled: true
          })
        ]
        $unchecked: [
          new Checkbox({color: 'blue'})
          new Checkbox({isDisabled: true})
        ]
      $errorInput:
        new Input({
          error: new Rx.BehaviorSubject 'Input is required'
          label: 'error'
          color: 'blue'
          isFloating: true
        })
      $inputs: [
        new Input({
          label: 'Regular'
          color: 'blue'
        })
        new Input({
          label: 'Floating'
          color: 'blue'
          isFloating: true
        })
        new Input({
          label: 'Disabled'
          color: 'blue'
          isFloating: true
          isDisabled: true
        })
      ]
      radios:
        $checked: [
          new Radio({color: 'blue', isChecked: new Rx.BehaviorSubject(true)})
          new Radio({
            isDisabled: true
            isChecked: new Rx.BehaviorSubject(true)
          })
        ]
        $unchecked: [
          new Radio({color: 'blue'})
          new Radio({isDisabled: true})
        ]

  afterMount: ($el) =>
    {$buttons, checkboxes, $actions, $fab,
    $errorInput, $inputs, radios} = @state.getValue()

    sectionAnchors = $el.querySelectorAll('a[name]')
    @scrollListener = =>
      for $anchor in sectionAnchors
        if isNodeVisible $anchor
          # FIXME: shared logic between menu
          [section, key] = $anchor.name.split '_'
          path = '/'
          unless section is 'intro' and not key
            if section
              path += section
            if key
              path += '/' + key
          @scrollToSubject.onNext {section, key}
          # FIXME: should be handled by zorium router?
          window.history?.replaceState? null, null, path
          break
    window.addEventListener 'scroll', @scrollListener

    _.map $el.querySelectorAll('a'), ($$el) ->
      isLocal = $$el.hostname is window.location.hostname
      unless isLocal
        $$el.target = '_blank'

    z.render $el.querySelector('#z-docs_paper-hack-shadows'),
      z '#z-docs_paper-hack-shadows.z-docs_paper-hack',
        z '.shadows',
          z '.box .height-1'
          z '.box .height-2'
          z '.box .height-3'
          z '.box .height-4'
          z '.box .height-5'

    z.render $el.querySelector('#z-docs_paper-hack-fonts'),
      z '#z-docs_paper-hack-fonts.z-docs_paper-hack',
        z '.fonts',
          _.map fonts, (font) ->
            z '.font',
              z 'span.var', font
              z "span.text.#{font}", 'Hello World'

    z.render $el.querySelector('#z-docs_paper-hack-buttons'),
      z '#z-docs_paper-hack-buttons.z-docs_paper-hack',
        z '.buttons',
          z $buttons[0],
            $children: 'button'
          z $buttons[1],
            $children: 'colored'
          z $buttons[2],
            $children: 'disabled'
          z $buttons[3],
            $children: 'raised'
          z $buttons[4],
            $children: 'colored'
          z $buttons[5],
            $children: 'disabled'

    renderCheckboxes = ->
      z.render $el.querySelector('#z-docs_paper-hack-checkboxes'),
        z '#z-docs_paper-hack-checkboxes.z-docs_paper-hack',
          z '.checkboxes',
            z checkboxes.$unchecked[0]
            z checkboxes.$checked[0]
            z checkboxes.$unchecked[1]
            z checkboxes.$checked[1]

    renderCheckboxes()
    _.map checkboxes.$unchecked.concat(checkboxes.$checked), (checkbox) ->
      checkbox.state.subscribe ->
        renderCheckboxes()

    renderInputs = ->
      z.render $el.querySelector('#z-docs_paper-hack-inputs'),
        z '#z-docs_paper-hack-inputs.z-docs_paper-hack',
          z '.inputs', [
            $inputs[0]
            $inputs[1]
            $errorInput
            $inputs[2]
          ]

    renderInputs()
    _.map $inputs.concat([$errorInput]), (input) ->
      input.state.subscribe ->
        renderInputs()


    renderRadios = ->
      z.render $el.querySelector('#z-docs_paper-hack-radios'),
        z '#z-docs_paper-hack-radios.z-docs_paper-hack',
          z '.radios', [
            radios.$unchecked[0]
            radios.$checked[0]
            radios.$unchecked[1]
            radios.$checked[1]
          ]

    renderRadios()
    _.map radios.$unchecked.concat(radios.$checked), (radios) ->
      radios.state.subscribe ->
        renderRadios()

  beforeUnmount: =>
    if @scrollListener
      window.removeEventListener 'scroll', @scrollListener

  render: ({title, page}) =>
    {$md1, $md2, $tutorial, $downloadBtn, $downloadSeedBtn, $getStartedBtn} =
      @state.getValue()

    z '.z-docs',
      z '.buttons',
        z 'a',
          href: '/tutorial',
          onclick: z.ev (e, $$el) =>
            if z.isSimpleClick e
              e.preventDefault()
              @router.go $$el.href
          z $getStartedBtn, $children: 'get started'
        z 'a',
          href: 'https://github.com/Zorium/zorium',
          target: '_blank',
          z $downloadBtn, $children: 'github'
        z 'a',
          href: 'https://github.com/Zorium/zorium-seed',
          target: '_blank',
          z $downloadSeedBtn, $children: 'seed'
      z $md1, html: intro
      $tutorial
      z $md2, html: [
        api
        bestPractices
        paper
      ].join ''
