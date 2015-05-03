# Intro

## A Simple Component

```coffee
z = require 'zorium'

class HelloMessage
  render: ({name}) ->
    z 'div',
      "Hello #{name}"

$hello = new HelloMessage()
z.render document.body, z $hello, name: 'Zorium'
```

## A Stateful Component

```coffee
z = require 'zorium'

class Timer
  constructor: ->
    @state = z.state
      secondsElapsed: 0
      interval: null

  tick: =>
    {secondsElapsed} = @state()
    @state.set
      secondsElapsed: secondsElapsed + 1

  onMount: =>
    @state.set
      interval: setInterval @tick, 1000

  onBeforeUnmount: =>
    {interval} = @state()
    clearInterval interval

  render: =>
    {secondsElapsed} = @state()
    z 'div',
      "Seconds Elapsed: #{secondsElapsed}"

z.render document.body, new Timer()
```

## An Application

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
