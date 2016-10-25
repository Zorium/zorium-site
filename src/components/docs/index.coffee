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
  router = require './router.md'
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
  router = MarkdownService.marked \
    fs.readFileSync __dirname + '/router.md', 'utf-8'
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
        new Button()
        new Button()
        new Button()
        new Button()
        new Button()
      ]
      checkboxes:
        $checked: [
          new Checkbox(isChecked: new Rx.BehaviorSubject(true))
          new Checkbox(isChecked: new Rx.BehaviorSubject(true))
        ]
        $unchecked: [
          new Checkbox()
          new Checkbox()
        ]
      $errorInput:
        new Input(error: new Rx.BehaviorSubject 'Input is required')
      $inputs: [
        new Input()
        new Input()
        new Input()
      ]
      radios:
        $checked: [
          new Radio(isChecked: new Rx.BehaviorSubject(true))
          new Radio(isChecked: new Rx.BehaviorSubject(true))
        ]
        $unchecked: [
          new Radio()
          new Radio()
        ]

  afterMount: ($el) =>
    {$buttons, checkboxes, $dialog, $actions,
    $dialogTrigger, $fab, $errorInput, $inputs, radios} = @state.getValue()

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
            colors:
              ink: paperColors.$red500
          z $buttons[2],
            $children: 'disabled'
            isDisabled: true
          z $buttons[3],
            $children: 'button'
            isRaised: true
          z $buttons[4],
            $children: 'colored'
            isRaised: true
            colors:
              cText: paperColors.$blue500Text
              c200: paperColors.$blue200
              c500: paperColors.$blue500
              c600: paperColors.$blue600
              c700: paperColors.$blue700
          z $buttons[5],
            $children: 'disabled'
            isRaised: true
            isDisabled: true

    renderCheckboxes = ->
      z.render $el.querySelector('#z-docs_paper-hack-checkboxes'),
        z '#z-docs_paper-hack-checkboxes.z-docs_paper-hack',
          z '.checkboxes',
            z checkboxes.$unchecked[0],
              colors:
                c500: paperColors.$blue500
            z checkboxes.$checked[0],
              colors:
                c500: paperColors.$blue500
            z checkboxes.$unchecked[1],
              isDisabled: true
            z checkboxes.$checked[1],
              isDisabled: true

    renderCheckboxes()
    _.map checkboxes.$unchecked.concat(checkboxes.$checked), (checkbox) ->
      checkbox.state.subscribe ->
        renderCheckboxes()

    isDialogVisible = false
    renderDialogs = ->
      z.render $el.querySelector('#z-docs_paper-hack-dialogs'),
        z '#z-docs_paper-hack-dialogs.z-docs_paper-hack',
          z $dialogTrigger,
            $children: 'open dialog'
            onclick: ->
              isDialogVisible = true
              renderDialogs()
          z '.dialogs',
            if isDialogVisible
              z $dialog,
                title: 'This is a title'
                content: z '.text', 'this is text contents'
                actions: [
                  {
                    $el: z $actions[0],
                      $children: 'disagree'
                      isShort: true
                      colors:
                        ink: paperColors.$blue500
                  }
                  {
                    $el: z $actions[1],
                      $children: 'agree'
                      isShort: true
                      colors:
                        ink: paperColors.$blue500
                  }
                ]
                onleave: ->
                  isDialogVisible = false
                  renderDialogs()

    renderDialogs()


    z.render $el.querySelector('#z-docs_paper-hack-fabs'),
      z '#z-docs_paper-hack-fabs.z-docs_paper-hack',
        z '.fabs',
          z $fab,
            colors:
              c500: paperColors.$blueGrey500
            $icon: z '.div',
              style:
                display: 'inline-block'
                width: '20px'
                height: '20px'
                margin: '2px'
                color: 'white'
                textAlign: 'center'
                lineHeight: '20px'
              , 'Z'

    renderInputs = ->
      z.render $el.querySelector('#z-docs_paper-hack-inputs'),
        z '#z-docs_paper-hack-inputs.z-docs_paper-hack',
          z '.inputs',
            z $inputs[0],
              hintText: 'Regular'
              colors:
                c500: paperColors.$blue500
            z $inputs[1],
              hintText: 'Floating'
              colors:
                c500: paperColors.$blue500
              isFloating: true
            z $errorInput,
              hintText: 'Error'
              colors:
                c500: paperColors.$blue500
              isFloating: true
            z $inputs[2],
              hintText: 'Disabled'
              colors:
                c500: paperColors.$blue500
              isFloating: true
              isDisabled: true


    renderInputs()
    _.map $inputs.concat([$errorInput]), (input) ->
      input.state.subscribe ->
        renderInputs()


    renderRadios = ->
      z.render $el.querySelector('#z-docs_paper-hack-radios'),
        z '#z-docs_paper-hack-radios.z-docs_paper-hack',
          z '.radios',
            z radios.$unchecked[0],
              colors:
                c500: paperColors.$blue500
            z radios.$checked[0],
              colors:
                c500: paperColors.$blue500
            z radios.$unchecked[1],
              isDisabled: true
            z radios.$checked[1],
              isDisabled: true

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
        router
        bestPractices
        paper
      ].join ''
