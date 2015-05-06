# TODO: replace with zorium shortcut
isRegularClickEvent = (e) ->
  not (e.which > 1 or e.shiftKey or e.altKey or e.metaKey or e.ctrlKey)

module.exports = {
  isRegularClickEvent
}
