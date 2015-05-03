# Router

## Example

```coffee
class App
  constructor: (params) ->
    @state = z.state
      key: params.key or 'none'

  render: =>
    {key} = @state()
    z 'div', 'Hello ' + key

root = document.createElement 'div'

z.router.setMode 'pathname' # 'pathname' or 'hash' (default is 'hash')

z.router.setRoot root
z.router.add '/test', App
z.router.add '/test/:key', App

z.router.go '/test'
```


## z.router.setMode() <a class="anchor" name="set-mode"></a>

```coffee
z.router.setMode 'hash' # (default) clay.io/#/path
z.router.setMode 'pathname' # clay.io/pathname
```


## z.router.setRoot() <a class="anchor" name="set-root"></a>

Accepts a DOM node to append to

```coffee
###
@param {HtmlElement}
###
z.router.setRoot(document.body)
```

## z.router.add() <a class="anchor" name="add"></a>

Variables will be passed into the component constructor.  
pathTransform will be called if provided, and may return a promise.
If the path returned by pathTransform differs from the original route, a redirect to the new route will occur.

```coffee
###
@param {String} path
@param {ZoriumComponent} App
@param {Function<String, Promise<String>>} [pathTransform=((path) -> path)]
###
z.router.add '/test/:key', App, pathTransform

class App
  constructor: (params) -> null

pathTransform = (path) ->
  isLoggedIn = new Promise (resolve) -> resolve false

  return isLoggedIn.then (isLoggedIn) ->
    unless isLoggedIn
      return '/login'

    return path
```

## z.router.go() <a class="anchor" name="go"></a>

Navigate to a route

```coffee
z.router.go '/test/one'
```

## z.router.link() <a class="anchor" name="link"></a>

automatically route anchor `<a>` tag elements
It is a mistake to use `onclick` on the element

```coffee
z 'div',
  z.router.link z 'a.myclass[href=/abc]', 'click me'
```


## z.router.currentPath <a class="anchor" name="current-path"></a>

This value will be set to the currently routed path that the router has routed to.

## z.router.on() <a class="anchor" name="on"></a>

Listen for events. Currently the only event is `route`, which emits the path.

```coffee
###
@param {String} key
@param {Function} callback
###
z.router.on 'route', (path) -> null
```
