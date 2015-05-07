z = require 'zorium'
Rx = require 'rx-lite'

Editor = require '../editor'
Md = require '../md'
util = require '../../lib/util'

if window?
  tutorial = require './tutorial.md'
else
  # Avoid webpack include
  _fs = 'fs'
  fs = require _fs

  tutorial = util.marked fs.readFileSync __dirname + '/tutorial.md', 'utf-8'

if window?
  require './index.styl'

module.exports = class Tutorial
  constructor: ->
    @editors = []

    @state = z.state
      $md: new Md()

  shouldShowEditor: ->
    window.matchMedia('(min-width: 800px)').matches

  onMount: ($$el) =>
    unless @shouldShowEditor()
      return

    @editors = _.map [
      '#z-tutorial_hack-first-component'
      '#z-tutorial_hack-stateful-components'
      '#z-tutorial_hack-composing-components'
      '#z-tutorial_hack-streams'
    ], (selector) ->

      $$editor = $$el.querySelector(selector)
      $$source = $$editor
        .previousSibling # text node
        .previousSibling # <pre>
      $editor = new Editor({$$source})

      renderEditor = ->
        z.render $$editor, $editor

      editorDisposable = $editor.state?.subscribe renderEditor

      {$$editor, editorDisposable}

  onBeforeUnmount: =>
    if _.isEmpty @editors
      return

    _.map @editors, ({$$editor, editorDisposable}) ->
      z.render $$editor, z()
      editorDisposable.dispose()

  render: =>
    {$md} = @state.getValue()

    z '.z-tutorial',
        z $md, html: tutorial
