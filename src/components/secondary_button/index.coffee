z = require 'zorium'
Button = require 'zorium-paper/button'
paperColors = require 'zorium-paper/colors.json'

module.exports = class SecondaryButton extends Button
  render: ({$content}) =>
    super {
      $content: $content
      isRaised: true
      colors:
        cText: paperColors.$blueGrey500Text
        c200: paperColors.$blueGrey200
        c500: paperColors.$blueGrey500
        c600: paperColors.$blueGrey600
        c700: paperColors.$blueGrey700
    }
