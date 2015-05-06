z = require 'zorium'
Rx = require 'rx-lite'

Editor = require '../editor'
Md = require '../md'
util = require '../../lib/util'

if window?
  first = require './first.md'
else
  # Avoid webpack include
  _fs = 'fs'
  fs = require _fs

  first = util.marked fs.readFileSync __dirname + '/first.md', 'utf-8'

if window?
  require './index.styl'

module.exports = class Tutorial
  constructor: ->
    @editorDisposable = null
    @$editor = null
    @$$editor = null

    @state = z.state
      $md: new Md()

  onMount: ($$el) =>
    @$$editor = $$el.querySelector('#z-tutorial_hack-editor')
    $$source = @$$editor
      .previousSibling # text node
      .previousSibling # <pre>
    @$editor = new Editor({$$source})

    renderEditor = =>
      z.render @$$editor, @$editor

    @editorDisposable = @$editor.state?.subscribe renderEditor

  onBeforeUnmount: =>
    z.render @$$editor, z()
    @editorDisposable?.dispose()

  render: =>
    {$md} = @state.getValue()

    z '.z-tutorial',
        z $md, html: first
