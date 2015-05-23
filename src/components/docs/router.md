# Router API <a class="anchor" name="router"></a>

## z.router.init() <a class="anchor" name="router_init"></a>

  - `mode` defaults to `pathname` if the [history api](https://developer.mozilla.org/en-US/docs/Web/Guide/API/DOM/Manipulating_the_browser_history) is available
    - possible values: `pathname`, `hash`
  - `$$root` is the DOM node to render to
    - for full page rendering this should be set to the `#zorium-root` element. See [full page rendering](/router/full-page-rendering)

```coffee
###
@param {Object}      config
@param {String}      config.mode
@param {HTMLElement} config.$$root
###

$$root = document.createElement 'div'

z.router.init {
  mode: 'pathname' # 'pathname' or 'hash'
  $$root: $$root
}
```

## z.router.use() <a class="anchor" name="router_use"></a>

  - defines an express-like interface for resolving a routing event

```coffee
###
@param {Function} callback - called with Request and Response
###

###
@define {Object} Request
@property {String} path - the pathname (excluding query parameters and hash)
@property {Object} query - the query parameters
###

###
@define {Object} Response
@property {Function} send - the Component to render
###

class App
  render: ->
    z 'div', 'hi'

$app = new App()
z.router.use (req, res) ->
  {path, query} = req
  res.send z $app, {req, res}
```

## z.router.go() <a class="anchor" name="router_go"></a>

  - route to the given path
  - this changes the page URL, causing a history pushState

```coffee
###
@param {String} path - defaults to current url
###

z.router.go '/path'
```

## z.router.link() <a class="anchor" name="router_link"></a>

  - Route `<a>` tags via [z.router.go()](/router/go)
  - Cannot be used on a node that already has `onclick` bound

```coffee
###
@returns virtual-dom tree
###

z 'div',
  z.router.link \
    z 'a', href: '/path', 'click me'
```

## Full Page Rendering <a class="anchor" name="router_full-page-rendering"></a>

  - When rendering the full page, a special structure must be used
    - (This is because some DOM nodes are non-writable)
    - Non-specified parts of the structure can be anything, but only $myComponent will update
    - `title` will update dynamically as well
  - The `#zorium-root` DOM node should be used as the `$$root` server node

```coffee
class App
  render: ->
    z 'html',              # required
      z 'head',            # required
        z 'title', 'title' # required (must be first node)
      z 'body',            # required
        z '#zorium-root',  # required (must be first node)
          $myComponent

z.router.init {
  $$root: document.getElementById 'zorium-root'
}
```
