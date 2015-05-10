z = require 'zorium'
Button = require 'zorium-paper/button'
paperColors = require 'zorium-paper/colors.json'

module.exports = class PrimaryButton extends Button
  render: ({$content, onclick}) =>
    super {
      $content: $content
      onclick: onclick
      isRaised: true
      colors:
        cText: paperColors.$teal500Text
        c200: paperColors.$teal200
        c500: paperColors.$teal500
        c600: paperColors.$teal600
        c700: paperColors.$teal700
    }
