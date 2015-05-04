z = require 'zorium'
_ = require 'lodash'
Rx = require 'rx-lite'
paperColors = require 'zorium-paper/colors.json'
Button = require 'zorium-paper/button'
Checkbox = require 'zorium-paper/checkbox'
Dialog = require 'zorium-paper/dialog'
FloatingActionButton = require 'zorium-paper/floating_action_button'
Input = require 'zorium-paper/input'
Radio = require 'zorium-paper/radio_button'

Md = require '../md'
PrimaryButton = require '../primary_button'
SecondaryButton = require '../secondary_button'

if window?
  home = require './home.md'
  api = require './api.md'
  server = require './server.md'
  router = require './router.md'
  paper = require './paper.md'
  architecture = require './architecture.md'
else
  # Avoid webpack include
  _fs = 'fs'
  fs = require _fs
  home = fs.readFileSync __dirname + '/home.md', 'utf-8'
  api = fs.readFileSync __dirname + '/api.md', 'utf-8'
  server = fs.readFileSync __dirname + '/server.md', 'utf-8'
  router = fs.readFileSync __dirname + '/router.md', 'utf-8'
  paper = fs.readFileSync __dirname + '/paper.md', 'utf-8'
  architecture = fs.readFileSync __dirname + '/architecture.md', 'utf-8'

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

module.exports = class Docs
  constructor: ->
    @state = z.state
      $md: new Md()
      $downloadBtn: new PrimaryButton()
      $downloadSeedBtn: new SecondaryButton()
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
          new Checkbox(isChecked: true)
          new Checkbox(isChecked: true)
        ]
        $unchecked: [
          new Checkbox()
          new Checkbox()
        ]
      $dialog: new Dialog()
      $dialogTrigger: new PrimaryButton()
      $actions: [
        new Button()
        new Button()
      ]
      $fab: new FloatingActionButton()
      $errorInput:
        new Input(error: new Rx.BehaviorSubject 'Input is required')
      $inputs: [
        new Input()
        new Input()
        new Input()
      ]
      radios:
        $checked: [
          new Radio(isChecked: true)
          new Radio(isChecked: true)
        ]
        $unchecked: [
          new Radio()
          new Radio()
        ]

  onMount: ($el) =>
    {$buttons, checkboxes, $dialog, $actions,
     $dialogTrigger, $fab, $errorInput, $inputs, radios} = @state.getValue()

    $ = _.bind document.querySelector, document

    z.render $('#z-docs_paper-hack-shadows'),
      z '.z-docs_paper-hack',
        z '.shadows',
          z '.box .height-1'
          z '.box .height-2'
          z '.box .height-3'
          z '.box .height-4'
          z '.box .height-5'

    z.render $('#z-docs_paper-hack-fonts'),
      z '.z-docs_paper-hack',
        z '.fonts',
          _.map fonts, (font) ->
            z '.font',
              z 'span.var', font
              z "span.text.#{font}", 'Hello World'

    z.render $('#z-docs_paper-hack-buttons'),
      z '.z-docs_paper-hack',
        z '.buttons',
          z $buttons[0],
            text: 'button'
          z $buttons[1],
            text: 'colored'
            colors:
              ink: paperColors.$red500
          z $buttons[2],
            text: 'disabled'
            isDisabled: true
          z $buttons[3],
            text: 'button'
            isRaised: true
          z $buttons[4],
            text: 'colored'
            isRaised: true
            colors:
              cText: paperColors.$blue500Text
              c200: paperColors.$blue200
              c500: paperColors.$blue500
              c600: paperColors.$blue600
              c700: paperColors.$blue700
          z $buttons[5],
            text: 'disabled'
            isRaised: true
            isDisabled: true

    renderCheckboxes = ->
      z.render $('#z-docs_paper-hack-checkboxes'),
        z '.z-docs_paper-hack',
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

    _.map checkboxes.$unchecked.concat(checkboxes.$checked), (checkbox) ->
      checkbox.state.subscribe ->
        renderCheckboxes()
    renderCheckboxes()

    isDialogVisible = false
    renderDialogs = ->
      z.render $('#z-docs_paper-hack-dialogs'),
        z '.z-docs_paper-hack',
          z $dialogTrigger,
            text: 'open dialog'
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
                      text: 'disagree'
                      isShort: true
                      colors:
                        ink: paperColors.$blue500
                  }
                  {
                    $el: z $actions[1],
                      text: 'agree'
                      isShort: true
                      colors:
                        ink: paperColors.$blue500
                  }
                ]
                onleave: ->
                  isDialogVisible = false
                  renderDialogs()

    renderDialogs()

    z.render $('#z-docs_paper-hack-fabs'),
      z '.z-docs_paper-hack',
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
      z.render $('#z-docs_paper-hack-inputs'),
        z '.z-docs_paper-hack',
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


    _.map $inputs.concat([$errorInput]), (input) ->
      input.state.subscribe ->
        renderInputs()

    renderInputs()

    renderRadios = ->
      z.render $('#z-docs_paper-hack-radios'),
        z '.z-docs_paper-hack',
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

    _.map radios.$unchecked.concat(radios.$checked), (radios) ->
      radios.state.subscribe ->
        renderRadios()
    renderRadios()

  render: ({title, page}) =>
    {$md, $downloadBtn, $downloadSeedBtn} = @state.getValue()

    z '.z-docs',
      z '.buttons',
        z 'a',
          href: 'https://github.com/Zorium/zorium',
          z $downloadBtn, text: 'github'
        z 'a',
          href: 'https://github.com/Zorium/zorium-seed',
          z $downloadSeedBtn, text: 'seed'
      z $md, html: [
        # home
        api
        server
        # router
        # paper
        # architecture
      ].join ''
