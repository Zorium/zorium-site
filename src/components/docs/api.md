# API

## Example

```coffee
z = require 'zorium'
_ = require 'lodash'

class TodoList
  render: ({items}) ->
    z 'ul',
      _.map items, (itemText) ->
        z 'li', itemText

class TodoApp
  constructor: ->
    @state = z.state
      items: []
      text: ''
      $todoList: new TodoList()

  render: =>
    {items, text} = @state()

    z 'div',
      z 'h3', 'TODO'
      z $todoList, items: items
      z 'form',
        onsubmit: (e) ->
          e.preventDefault()
          @state.set
            items: items.concat [text]
            text: ''efault()

        z 'input',
          value: value
          oninput: z.ev (e, $$el) =>
            @state.set value: $$el.value
        z 'input[type=submit]', value: "Add ##{items.length + 1}"

z.render document.body, new TodoApp()
```

## z() <a class="anchor" name="z"></a>

```coffee
z '.container' # <div class='container'></div>

z '#layout' # <div id='layout'></div>

z 'a[name=top]' # <a name='top'></a>

z '[contenteditable]' # <div contenteditable='true'></div>

z 'a#google.external[href=http://google.com]', 'Google' # <a id='google' class='external' href='http://google.com'>Google</a>

z 'div', {style: {border: '1px solid red'}}  # <div style='border:1px solid red;'></div>
```

```coffee
z 'ul',
  z 'li', 'item 1'
  z 'li', 'item 2'

###
<ul>
    <li>item 1</li>
    <li>item 2</li>
</ul>
###
```

### Zorium Components

Zorium components can be used in place of a dom tag.  
Zorium components must have a `render()` method

```coffee
class HelloWorldComponent
  render: ->
    z 'span', 'Hello World'

$hello = new HelloWorldComponent()

z 'div',
  z $hello # <div><span>Hello World</span></div>
```

Parameters can also be passed to the render method

```coffee
class A
  render: ({world}) ->
    z 'div', 'hello ' + world

class B
  constructor: ->
    @state = z.state
      $a: new A()
  render: =>
    {$a} = @state()
    z $a, {world: 'world'}

$b = new B()
root = document.createElement 'div'
z.render root, $b # <div><div>hello world</div></div>
```

### Lifecycle Hooks

If a component has a hook method defined, it will be called

```coffee
class BindComponent
  onMount: ($el) ->
    # called after $el has been inserted into the DOM
    # $el is the rendered DOM node

  onBeforeUnmount: ->
    # called before the element is removed from the DOM

  render: ->
    z 'div',
      z 'span', 'Hello World'
      z 'span', 'Goodbye'
```


## z.render() <a class="anchor" name="render"></a>

```coffee
###
@param {HtmlElement} root
@param {ZoriumComponent} App
###
z.render document.body, App
```

## z.redraw() <a class="anchor" name="redraw"></a>

Redraw all previously rendered elements  
This is called whenever a component's `state` is changed  
Call this whenever something changes the DOM state

```coffee
z.render document.body, z 'div'
z.redraw()
```

## z.state() <a class="anchor" name="state"></a>

Partial updating state object  
When set as a property of a Zorium Component, `z.redraw()` will automatically be called  
If passed a `z.observe`, an update is triggered on child updates

```coffee
promise = new Promise()

state = z.state
  a: 'abc'
  b: 123
  c: [1, 2, 3]
  d: z.observe promise

state() is {
  a: 'abc'
  b: 123
  c: [1, 2, 3]
  d: null
}

promise.resolve(123)

# promise resolved
state().d is 123

# watch for changes
state (state) ->
  state.b is 321

# partial update
state.set
  b: 321

state() is {
  a: 'abc'
  b: 123
  c: [1, 2, 3]
  d: 123
}
```

## z.observe() <a class="anchor" name="observe"></a>

Create an observable  
Promises observe to `null` until resolved (but still have promise methods)

```coffee
a = z.observe 'a'
a() is 'a'

a (change) ->
  change is 'b'

a.set('b')

resolve = null
promise = new Promise (_resolve) -> resolve = _resolve
p = z.observe(promise)
p() is null
resolve(1)

p.then ->
  p() is 1

```

## z.ev() <a class="anchor" name="ev"></a>

pass event context to callback fn

```coffee
z 'div',
  onclick: z.ev (e, $$el) ->
    # `e` is the original event
    # $$el is the event source element which triggered the event
```
