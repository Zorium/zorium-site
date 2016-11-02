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
@constructor
@param {ZoriumComponent} $content
@param {Function} onclick
@param {String} type - e.g. `submit` for forms
@param {Boolean} [isDisabled=false]
@param {Boolean} [isRaised=false]
@param {String} color - a material design color name

render()
@param {ZoriumComponent} $children
###

Button = require 'zorium-paper/button'

$button = new Button({
  color: 'red'
  isRaised: true
  isDisabled: true
})

z $button,
  $children: 'click me'
```

<div id="z-docs_paper-hack-buttons"></div>

## Checkbox <a class="anchor" name="paper_checkbox"></a>

```coffee
###
@constructor
@param {Rx.Subject} [isChecked=Rx.BehaviorSubject(false)]
@param {String} color - a material design color name
@param {Boolean} [isDisabled=false]
###

Rx = require 'rx-lite'
Checkbox = require 'zorium-paper/checkbox'
paperColors = require 'zorium-paper/colors.json'

isChecked = new Rx.BehaviorSubject(false)
$checkbox = new Checkbox({isChecked, color: 'blue', isDisabled: false})
```

<div id="z-docs_paper-hack-checkboxes"></div>

## Input <a class="anchor" name="paper_input"></a>

```coffee
###
@constructor
@param {Rx.Observable} [value=Rx.Observable.just('')] - value stream
@param {Rx.Observable} [error=Rx.Observable.just(null)]
@param {Rx.Subject} [value=Rx.BehaviorSubject('')] - change stream
@param {Rx.Subject} [error=Rx.BehaviorSubject(null)]
@param {String} color - a material design color name
@param {String} label
@param {String} type
@param {Boolean} isFloating
@param {Boolean} isDisabled
@param {Boolean} autocapitalize
###

Rx = require 'rx-lite'
Input = require 'zorium-paper/input'
paperColors = require 'zorium-paper/colors.json'

value = new Rx.BehaviorSubject('')
error = new Rx.BehaviorSubject(null)
$input = new Input({
  value
  error
  label: 'label text'
  color: 'blue'
  isDisabled: true
})
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
