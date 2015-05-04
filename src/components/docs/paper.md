# Paper - Material Design <a class="anchor" name="paper"></a>

## Install

[Source](https://github.com/Zorium/zorium-paper)

```bash
npm install -S zorium-paper
```

Use these webpack loaders

```bash
npm install -S style-loader css-loader autoprefixer-loader stylus-loader coffee-loader json-loader
```

```coffee
{ test: /\.coffee$/, loader: 'coffee' }
{ test: /\.json$/, loader: 'json' }
{
  test: /\.styl$/
  loader: 'style!css!autoprefixer!stylus?' +
          'paths[]=bower_components&paths[]=node_modules'
}
```

And make sure you have the Roboto font

```html
<link href='http://fonts.googleapis.com/css?family=Roboto:400,300,500' rel='stylesheet' type='text/css'>
```


## Shadows <a class="anchor" name="paper_shadows"></a>

Shadow methods are found in `base.styl`

```stylus
@require 'zorium-paper/base'

zp-shadow-1()
zp-shadow-2()
zp-shadow-3()
zp-shadow-4()
zp-shadow-5()
```

<div id="z-docs_paper-hack-shadows"></div>


## Fonts <a class="anchor" name="paper_fonts"></a>

Font methods are found in `base.styl`

```stylus
@require 'zorium-paper/base'

zp-font-display4()
zp-font-display3()
zp-font-display2()
zp-font-display1()
zp-font-headline()
zp-font-title()
zp-font-subhead()
zp-font-body2()
zp-font-body1()
zp-font-caption()
zp-font-button()
```

<div id="z-docs_paper-hack-fonts"></div>

## Colors <a class="anchor" name="paper_colors"></a>

Colors are found in `colors.json` and can be used in both Stylus and CoffeeScript.  
See [Google Material Design Colors](http://www.google.com/design/spec/style/color.html)
for all available colors.

Text colors refer to the font-color which should be used on top of that primary color.  
e.g. A background of $red500 should have text colored $red500Text

```stylus
json('zorium-paper/colors.json')

$black // #000000
$black12 // rgba(0, 0, 0, 0.12)
$black26 // rgba(0, 0, 0, 0.26)
$black54 // rgba(0, 0, 0, 0.54)
$black87 // rgba(0, 0, 0, 0.87)

$white // #FFFFFF
$white12 // rgba(255, 255, 255, 0.12)
$white30 // rgba(255, 255, 255, 0.30)
$white70 // rgba(255, 255, 255, 0.70)

$red50 // #FFEBEE
$red100 // #FFCDD2
$red200 // #EF9A9A
$red300 // #E57373
...

$red100Text // rgba(0, 0, 0, 0.87)
$red500Text // #FFFFFF
...

$lightBlue50Text // rgba(0, 0, 0, 0.87)
$lightBlue100Text // rgba(0, 0, 0, 0.87)
...
```

## Button <a class="anchor" name="paper_button"></a>

```coffee
###
@param {ZoriumComponent} $content
@param {Function} onclick
@param {Boolean} [isDisabled=false]
@param {Boolean} [isRaised=false]
@param {Boolean} [isFullWidth=false]
@param {Boolean} [isShort=false]
@param {Boolean} [isDark=false]  
@param {String} type - e.g. `submit` for forms
@param {Object} colors
@param {String} [colors.cText=colors.ink]
@param {String} [colors.c200=$grey500/$grey800]
@param {String} colors.c500
@param {String} colors.c600
@param {String} colors.c700
@param {String} colors.ink
###

Button = require 'zorium-paper/button'
paperColors = require 'zorium-paper/colors.json'

$button = new Button()

z $button,
  $content: 'click me'
  isRaised: true
  colors:
    cText: paperColors.$red500
    c200: paperColors.$blue200
    c500: paperColors.$blue500
    c600: paperColors.$blue600
    c700: paperColors.$blue700
    ink: paperColors.$red500
  isDisabled: true
  isDark: true
```

<div id="z-docs_paper-hack-buttons"></div>

## Checkbox <a class="anchor" name="paper_checkbox"></a>

```coffee
###
@constructor
@param {Rx.Subject} [isChecked=Rx.BehaviorSubject(false)]

@param {Object} colors
@param {String} [colors.c500=$black]
@param {Boolean} [isDisabled=false]
@param {Boolean} [isDark=false]
###

Rx = require 'rx-lite'
Checkbox = require 'zorium-paper/checkbox'
paperColors = require 'zorium-paper/colors.json'

isChecked = new Rx.BehaviorSubject(false)
$checkbox = new Checkbox({isChecked})

z $checkbox,
  colors:
    c500: paperColors.$blue500
  isDisabled: true
  isDark: true
```

<div id="z-docs_paper-hack-checkboxes"></div>

## Dialog <a class="anchor" name="paper_dialog"></a>

```coffee
###
@param {String} title
@param {ZoriumComponent} [$content='']
@param {Array<Action>} [actions=[]]
@param {Function} [onleave=_.noop]

@define {Object} Action
@property {ZoriumComponent} $el
###

Dialog = require 'zorium-paper/dialog'
Button = require 'zorium-paper/button'
paperColors = require 'zorium-paper/colors.json'

$dialog = new Dialog()
$action1 = new Button()
$action2 = new Button()

z $dialog,
  content: z '.text', 'this is text contents'
  actions: [
    {
      $el: z $action1,
        text: 'disagree'
        isShort: true
        colors:
          ink: paperColors.$blue500
    }
    {
      $el: z $action2,
        text: 'agree'
        isShort: true
        colors:
          ink: paperColors.$blue500
    }
  ]
  onleave: =>
    @toggle()
```

<div id="z-docs_paper-hack-dialogs"></div>

## Floating Action Button <a class="anchor" name="paper_floating-action-button"></a>

```coffee
###
@param {ZoriumComponent} $icon
@param {Function} onclick
@param {Object} colors
@param {String} [colors.c500=$black]
@param {Boolean} isMini
###
FloatingActionButton = require 'zorium-paper/floating_action_button'
paperColors = require 'zorium-paper/colors.json'

$fab = new FloatingActionButton()

z $fab,
  colors:
    c500: paperColors.$red500
  $icon: z '.div',
    style:
      display: 'inline-block'
      width: '20px'
      height: '20px'
      margin: '2px'
      background: 'black'
      color: 'white'
      textAlign: 'center'
      lineHeight: '20px'
    , 'Z'
```

<div id="z-docs_paper-hack-fabs"></div>

## Input <a class="anchor" name="paper_input"></a>

```coffee
###
@constructor
@param {Rx.Subject} [value=Rx.BehaviorSubject('')]
@param {Rx.Subject} [error=Rx.BehaviorSubject(null)]

@param {Object} colors
@param {String} [colors.c500=$black]
@param {String} hintText
@param {String} type
@param {Boolean} isFloating
@param {Boolean} isDisabled
@param {Boolean} isDark
###

Rx = require 'rx-lite'
Input = require 'zorium-paper/input'
paperColors = require 'zorium-paper/colors.json'

value = new Rx.BehaviorSubject('')
error = new Rx.BehaviorSubject(null)
$input = new Input({value, error})

z $input,
  hintText: 'hint text'
  colors:
    c500: paperColors.$blue500
  isDisabled: true
  isDark: true
```

<div id="z-docs_paper-hack-inputs"></div>

## Radio Button <a class="anchor" name="paper_radio-button"></a>

```coffee
###
@constructor
@param {Rx.Subject} [isChecked=Rx.BehaviorSubject(false)]

@param {Object} colors
@param {String} [colors.c500=$black]
@param {Boolean} [isDisabled=false]
@param {Boolean} [isDark=false]
###

Rx = require 'rx-lite'
RadioButton = require 'zorium-paper/radio_button'
paperColors = require 'zorium-paper/colors.json'

isChecked = new Rx.BehaviorSubject(false)
$radio = new RadioButton({isChecked})

z $radio,
  colors:
    c500: paperColors.$blue500
  isDisabled: true
  isDark: true
```

<div id="z-docs_paper-hack-radios"></div>
