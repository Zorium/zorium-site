# Core API <a class="anchor" name="api"></a>

## z() <a class="anchor" name="api_z"></a>

### Basic DOM construction

```coffee
###
@returns virtual-dom tree
###

z '.container' # <div class='container'></div>
z '#layout' # <div id='layout'></div>
z 'span' # <span></span
z 'a', {
  href: 'http://google.com' # <a href='http://google.com' style='border:1px solid red;'></a>
  style:
      border: '1px solid red'
}
z 'span', 'text!'  # <span>text!</span
```

```coffee
z 'ul',           # <ul>
  z 'li', 'item 1'    # <li>item 1</li>
  z 'li', 'item 2'    # <li>item 2</li>
                  # </ul>

z 'div',    # <div>
  z 'div',     # <div>
    z 'span'      # <span></span>
    z 'img'       # <img></img>
               # </div>
            # </div>
```

### Events

```coffee
# <button>click me</button>
z 'button', {
  onclick: (e) -> alert(1)
  ontouchstart: (e) -> alert(2)
  # ...
}, 'click me'
```

## Zorium Components <a class="anchor" name="api_components"></a>

### Basic

  - must have a `render()` method
  - can be used the same as a DOM tag

```coffee
class HelloWorldComponent
  render: ->
    z 'span', 'Hello World'

$hello = new HelloWorldComponent()

z 'div',
  z $hello # <div><span>Hello World</span></div>
```

### Parameters

Parameters can also be passed to the render method

```coffee
class A
  render: ({name}) ->
    z 'div', "Hello #{name}!"

$a = new A()

z 'div',
  z $a, {name: 'Zorium'} # <div><div>Hello Zorium!</div></div>
```

### Lifecycle Hooks

  - `afterMount()` called with element when inserted into the DOM
  - `beforeUnmount()` called before the element is removed from the DOM

```coffee
class BindComponent
  afterMount: ($el) ->
    # called after $el has been inserted into the DOM
    # $el is the rendered DOM node

  beforeUnmount: ->
    # called before the element is removed from the DOM

  render: ->
    z 'div',
      z 'span', 'Hello World'
      z 'span', 'Goodbye'
```

## z.state() <a class="anchor" name="api_state"></a>

  - z.state() creates an [Rx.BehaviorSubject](https://github.com/Reactive-Extensions/RxJS/blob/master/doc/api/subjects/behaviorsubject.md)
with a `set()` method for partial updates
    - To get current value, call `state.getValue()`
  - Properties may be a [Rx.Observable](https://github.com/Reactive-Extensions/RxJS/blob/master/doc/libraries/rx.lite.md)
, whose updates propagate to state
  - Changes that occur in a components state cause a re-render
  - Observables on state are lazy.  
    - i.e. They are subscribed-to when creating the virtual-dom tree  
    - This is important because it allows for efficient lazy resource binding.  
    - See [State Management](/best-practices/state-management) for more info.

```coffee
###
@param {Object} initialValue
@returns {Rx.BehaviorSubject} (with set() method)
###

Rx = require 'rx-lite'
promise = new Promise()

state = z.state {
  a: 'abc'
  b: 123
  c: [1, 2, 3]
  d: Rx.Observable.fromPromise promise
}

state.getValue() is {
  a: 'abc'
  b: 123
  c: [1, 2, 3]
  d: null
}

promise.resolve(123)

# promise resolved
state.getValue().d is 123

# partial update
state.set
  b: 321

state.getValue() is {
  a: 'abc'
  b: 123
  c: [1, 2, 3]
  d: 123
}
```

### In components

```coffee
class Stateful
  constructor: ->
    @meSubject = new Rx.BehaviorSubject 'me'
    @state = z.state
      me: @meSubject

  render: =>
    {me} = @state.getValue()

    z 'button',
      onclick: =>
        @meSubject.onNext 'you'
      me
```

## z.render() <a class="anchor" name="api_render"></a>

Render a virtual-dom tree to a DOM node

```coffee
###
@param {HtmlElement} $$root
@param {ZoriumComponent} $app
###

$$domNode = document.createElement 'div'
$component = z 'div', 'test'

z.render $$domNode, $component
```

## z.renderToString() <a class="anchor" name="api_render-to-string"></a>

Render a virtual-dom tree to a string  
Completes after all states have settled to a value, or the request times out.  
The default timeout is 250ms.  
Errors may contain the last successful rendering (in case of timeout or error) on `error.html`  

**Note: Server-Side rendering is meant to stay separate from the API layer and only pre-render the DOM.  
i.e. keep the client-server model you would use for a single-page application**

```coffee
###
@param {ZoriumComponent} $app
@param {Object} config
@param {Number} config.timeout - ms

@returns {Promise}
###

z.renderToString z 'div', 'hi'
.then (html) ->
  # <div>hi</div>

class Timeout
  constructor: ->
    @state = z.state
      never: Rx.Observable.empty()
  render: ({abc}) ->
    z 'div', 'never ' + abc

$instance = z new Timeout(), {abc: 'abc'}
z.renderToString $instance, {timeout: 100}
.catch (err) ->
  err.html # <div>never abc</div>
```

## z.bind() <a class="anchor" name="api_bind"></a>

Bind a virtual-dom tree to a DOM node. This watches state changes and re-draws on update.

```coffee
###
@param {HtmlElement} $$root
@param {ZoriumComponent} $app
###

$$domNode = document.createElement 'div'
$component = z 'div', 'test'

z.bind $$domNode, $component
```

## z.untilStable() <a class="anchor" name="api_until-stable"></a>

Wait for all components in tree to have values for asyncronous data.

```coffee
###
@param {ZoriumComponent} $component
@returns {Promise}
###

class Component
  constructor: ->
    @state = z.state
      model: Rx.Observable.defer ->
        window.fetch '/demo'
        .then (res) -> res.json()
  render: =>
    {model} = @state.getValue()
    z '.z-component',
      if model?
        "model: #{JSON.stringify(model, null, 2)}"

z.untilStable new Component()
.then -> 'stable'
.catch -> 'error'
```

## z.ev() <a class="anchor" name="api_ev"></a>

  - helper method for accessing event DOM nodes

```coffee
###
@params {Function} callback
@returns {Function}
###

z 'div',
  onclick: z.ev (e, $$el) ->
    # `e` is the original event
    # $$el is the event source element which triggered the event
```

## z.classKebab() <a class="anchor" name="api_class-kebab"></a>

  - helper method for defining css state using [kebab-case](https://lodash.com/docs#kebabCase)

```coffee
###
@params {Object} - truthy keys converted to kebab-case
@returns {String}
###

z 'div',
  className: z.classKebab {
    isActive: true
    isGreen: false
    isRed: true
  }
# <div class='is-active is-red'></div>
```

## z.isSimpleClick() <a class="anchor" name="api_is-simple-click"></a>

  - helper method for checking if left click is not using modifier keys
    - see [this post](http://www.jacklmoore.com/notes/click-events/) for more information

```coffee
###
@params {Event} e - click event
@returns {Boolean}
###

z 'a',
  href: 'http://google.com'
  onclick: (e) ->
    if z.isSimpleClick e
      e.preventDefault()
      console.log 'do something'
```
