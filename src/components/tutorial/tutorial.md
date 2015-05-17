# Tutorial <a class="anchor" name="tutorial"></a>

## First Component <a class="anchor" name="tutorial_first-component"></a>

Zorium components make up the backbone of your application.  
They should be modular, composable, and simple.  
The `render` method of each component may be called many times, and must be [idempotent](http://en.wikipedia.org/wiki/Idempotence).

```coffee
# Live Editor
z = require 'zorium'

module.exports = class HelloWorld
  render: ->
    z 'h1.z-hello-world',
      'hello world' # Change me
```
<div id="z-tutorial_hack-first-component"></div>

## Stateful Components <a class="anchor" name="tutorial_stateful-components"></a>

Just rendering DOM doesn't help us much. Let's add some state to make a counter.  

```coffee
# Live Editor
z = require 'zorium'

module.exports = class Counter
  constructor: ->
    @state = z.state
      count: 0

  handleClick: =>
    {count} = @state.getValue()
    @state.set count: count + 1

  render: =>
    {count} = @state.getValue()

    z '.z-counter',
      z 'h1', "#{count}"
      z 'button',
        style: fontSize: '16px'
        onclick: @handleClick
        'increment'

```
<div id="z-tutorial_hack-stateful-components"></div>

## Composing Components <a class="anchor" name="tutorial_composing-components"></a>

Alright, let's make things interesting. Components compose just like regular DOM elements.  
There is no magic, just passing parameters to the `render()` method

```coffee
# Live Editor
z = require 'zorium'
Button = require 'zorium-paper/button'

class Brick
  render: ({size}) ->
    z '.z-brick',
      style: # normally this would go in a .styl file
        width: "#{size * 20}px"
        height: '20px'
        background: '#FF9800'
        margin: '20px'

module.exports = class House
  constructor: ->
    @state = z.state
      $button: new Button()
      $bricks: _.map _.range(10), -> new Brick()

  render: =>
    {$button, $bricks} = @state.getValue()

    z '.z-house',
      z $button, # A Material Design Button
        $content: 'Hello World'
        isRaised: true

      _.map $bricks, ($brick, i) -> # Bricks!
        z $brick, {size: i + 1}

```
<div id="z-tutorial_hack-composing-components"></div>

## Streams <a class="anchor" name="tutorial_streams"></a>

Finally, let's work some [FRP](http://en.wikipedia.org/wiki/Functional_reactive_programming) awesomeness into our components.  
Remember that streams should be `cold`, meaning that they only emit values when `subscribe()` is called.  
[Rx Observables](https://github.com/Reactive-Extensions/RxJS) are first-class citizens in Zorium

```coffee
z = require 'zorium'
Rx = require 'rx-lite'

module.exports = class Elegant
  constructor: ->
    @state = z.state
      pureAwesome: Rx.Observable.defer ->
        Rx.Observable.interval(200)
      model: Rx.Observable.defer ->
        window.fetch '/demo'
        .then (res) -> res.json()

  render: =>
    {pureAwesome, model} = @state.getValue()

    z '.z-elegant',
      z 'h1',
        "Pure Awesome: #{pureAwesome}"
      if model? # Yes, you can use if statements!
        z 'pre',
          "model: #{JSON.stringify(model, null, 2)}"
```
<div id="z-tutorial_hack-streams"></div>


## Server-side rendering <a class="anchor" name="tutorial_server-side-rendering"></a>

Zorium is built from the ground-up to support server-side rendering.  
All application code should simply work in a plain `Node.js` environment, without any special modification.  
Network requests can run seamlessly server-side to generate a complete DOM (with caching).  
For a more in-depth example, check out the [Zorium Seed](https://github.com/Zorium/zorium-seed) project.

```coffee
class App
  render: ({req, res}) ->
    z 'html',
      z 'head',
        z 'title', 'Simply Zorium'
      z 'body',
        z '#zorium-root',
          switch path
            when '/'
              z 'div', 'Welcome'
            else
              res.status? 404 # server-side
              z 'div', 'Oh No! 404'

express = require 'express'
app = express()
app.use (req, res) ->
  z.renderToString z new App(), {req, res}
  .then (html) ->
    res.send '<!DOCTYPE html>' + html
  .catch (err) ->
    if err.html
      log.trace err
      res.send '<!DOCTYPE html>' + err.html
    else
      next err
app.listen 3000
```
