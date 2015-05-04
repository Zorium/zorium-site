# Server API <a class="anchor" name="server"></a>

## z.server.link() <a class="anchor" name="server_link"></a>

  - Route `<a>` tags via [z.server.go()](/server/go)

```coffee
###
@returns virtual-dom tree
###

z 'div',
  z.server.link \
    z 'a', href: '/path', 'click me'
```

## z.server.set() <a class="anchor" name="server_set"></a>

  - `mode` defaults to `pathname` if the [history api](https://developer.mozilla.org/en-US/docs/Web/Guide/API/DOM/Manipulating_the_browser_history) is available
    - possible values: `pathname`, `hash`
  - `$$root` is the target to render updates from `factory()`
    - if set to `document` it assumes full-page rendering. See [full page rendering](/server/full-page-rendering)
  - `factory` should return a Zorium component

```coffee
###
@param {Object}      config
@param {String}      config.mode
@param {HTMLElement} config.$$root
@param {Function}    config.factory
###

class App
  render: ->
    z 'div', 'hello'

factory = ->
  return new App()

$$root = document.createElement 'div'

z.server.set {
  mode: 'hash'
  $$root: $$root
  factory: factory
}
```

## z.server.go() <a class="anchor" name="server_go"></a>

  - route to the given path
    - this changes the page URL
    - the path is passed as [parameters](/api/components)

```coffee
###
@param {String} path
###

z.server.go '/path'

# In-depth

class App
  render: ({path}) ->
    z 'div', "this is path #{path}"

z.server.set {
  $$root: document.createElement 'div'
  factory: -> new App()
}
z.server.go '/hi'

# $$root now is <div><div>this is path /hi</div></div>
```

## z.server.on() <a class="anchor" name="server_on"></a>

  - listen for events
    - currently only `route`

```coffee
###
@param {String} event
@param {Function} callback
###

z.server.on 'route', (path) -> path is '/hi'
z.server.go '/hi'
```

## z.server.off() <a class="anchor" name="server_off"></a>

```coffee
###
@param {String} event
@param {Function} callback
###

listener = (path) -> path is '/hi'
z.server.on 'route', listener
z.server.go '/hi'
z.server.off 'route', listener
```

## z.server.Redirect <a class="anchor" name="server_redirect"></a>

  - `Redirect` is a class, which when throw from `render()` routes to the path
    - Server-side this returns a `302` redirect

```coffee
###
@class z.server.Redirect

@constructor
@param {Object} options
@param {String} options.path
###
class NotHere
  render: ->
    throw new z.server.Redirect path: '/404'
```

## z.server.setStatus() <a class="anchor" name="server_set-status"></a>

  - sets the server-side response status code
    - e.g. `404`

```coffee
###
@param {Number} httpStatusCode
###

class App
  render: ->
    if is404
      z.setStatus 404
```

## Full Page Rendering <a class="anchor" name="server_full-page-rendering"></a>

  - When rendering the full page, a special structure must be used
    - (This is because some DOM nodes are non-writable)
    - Non-specified parts of the structure can be anything, but only $myComponent will update
    - `title` will update dynamically as well
  - `document` should be used as the $$root server node

```coffee
class App
  render: ->
    z 'html',              # required
      z 'head',            # required
        z 'title', 'title' # required (must be first node)
      z 'body',            # required
        z '#zorium-root',  # required (must be first node)
          $myComponent     # required (must be a single component)

z.server.set {
  $$root: document
  factory: -> new App()
}
```

## z.server.factoryToMiddleware <a class="anchor" name="server_factory-to-middleware"></a>

  - Creates an [Express Middleware](http://expressjs.com/guide/using-middleware.html) for server-side rendering
    - Note that the application **must be stateless**
    - The `factory()` method passed to the server must create a **clean environment**


```coffee
# Server-side code

class App
  render: ->
    z 'div', 'hi'

factory = ->
  new App()

express = require 'express'
app = express()
app.use z.server.factoryToMiddleware factory
app.listen 3000
```

Sometimes state cannot be avoided easily.  
In these circumstances clearing the state in the factory method is acceptable

```coffee
factory = ->
  StateService.clear()
  new App()
```
