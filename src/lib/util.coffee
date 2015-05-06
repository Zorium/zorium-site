# TODO: replace with zorium shortcut
isRegularClickEvent = (e) ->
  not (e.which > 1 or e.shiftKey or e.altKey or e.metaKey or e.ctrlKey)

marked = if window?
  -> throw new Error 'marked called client-side'
else
  _marked = 'marked'
  _hljs = 'highlight.js'
  marked = require _marked
  hljs = require _hljs

  marked.setOptions
    renderer: new marked.Renderer()
    gfm: true
    tables: true
    breaks: false
    pedantic: false
    sanitize: false
    smartLists: true
    smartypants: false
    highlight: (code, lang) ->
      hljs.highlight(lang, code).value
  marked

module.exports = {
  isRegularClickEvent
  marked
}
