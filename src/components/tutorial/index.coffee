z = require 'zorium'
Rx = require 'rx-lite'

Editor = require '../editor'
Md = require '../md'
MarkdownService = require '../../services/markdown'

if window?
  tutorial = require './tutorial.md'
else
  # Avoid webpack include
  _fs = 'fs'
  fs = require _fs

  tutorial = MarkdownService.marked \
    fs.readFileSync __dirname + '/tutorial.md', 'utf-8'

if window?
  require './index.styl'

module.exports = class Tutorial
  constructor: ->
    @editors = []

    @state = z.state
      $md: new Md()

  shouldShowEditor: ->
    window.matchMedia('(min-width: 800px)').matches

  afterMount: ($$el) =>
    unless @shouldShowEditor()
      return

    _.map $$el.querySelectorAll('a'), ($$el) ->
      isLocal = $$el.hostname is window.location.hostname
      unless isLocal
        $$el.target = '_blank'

    @editors = _.map [
      '#z-tutorial_hack-first-component'
      '#z-tutorial_hack-stateful-components'
      '#z-tutorial_hack-composing-components' # FIXME: use z.bind() for sub-comp
      '#z-tutorial_hack-streams'
    ], (selector) ->

      $$editor = $$el.querySelector(selector)
      $$source = $$editor.previousSibling
      if $$source.tagName isnt 'PRE'
        $$source = $$source.previousSibling
      $editor = new Editor({$$source})

      renderEditor = ->
        z.render $$editor, $editor

      renderEditor()
      editorDisposable = $editor.state?.subscribe renderEditor

      {$$editor, editorDisposable}

  beforeUnmount: =>
    if _.isEmpty @editors
      return

    _.map @editors, ({$$editor, editorDisposable}) ->
      z.render $$editor, z()
      editorDisposable.dispose()

  render: =>
    {$md} = @state.getValue()

    z '.z-tutorial',
        z $md, html: tutorial
