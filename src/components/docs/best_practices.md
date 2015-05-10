# Best Practices <a class="anchor" name="best-practices"></a>

## Zorium Seed <a class="anchor" name="best-practices_zorium-seed"></a>

[Zorium Seed](https://github.com/Zorium/zorium-seed) is a starter-project for Zorium  
It follows current best practices (both industry and Zorium),  
and is the recommended starting point for any new Zorium project.

Special takeaways from the project:

  - [Webpack](http://webpack.github.io/) (packaging tool)
  - [RxJS](https://github.com/Reactive-Extensions/RxJS) (functional reactive programming)
  - [Istanbul](https://github.com/gotwarlost/istanbul) (code coverage)
  - [Gulp](http://gulpjs.com/) (build tool)
  - [Karma](http://karma-runner.github.io/0.12/index.html) (unit testing)
  - [Stylus](https://learnboost.github.io/stylus/) (css pre-processor)
  - [WebdriverIO](http://webdriver.io/) (functional testing)

### Components

```coffee
# /component/my_component/index.coffee
z = require 'zorium'

if window?
  require './index.styl'

module.exports = class MyComponent
  render: ->
    z '.z-my-component', 'hi'
```

### Pages

```coffee
# /pages/my_page/index.coffee
z = require 'zorium'

module.exports = class MyPage
  renderHead: ->
    z 'head',
      z 'title', 'title'
  render: ->
    z 'div', 'hi'
```

### Services

  - Note that it must be stateless, or use StateService as described [here](/server/factory-to-middleware)

```coffee
# /services/my_service.coffee
class MyService
  transformPath: -> '/test'

module.exports = new MyService()
```

### Models

  - Note that it must be stateless, or use StateService as described [here](/server/factory-to-middleware)

```coffee
# /models/my_model.coffee
RequestService = require '../services/request'

class MyModel
  getById: (id) ->
    RequestService.getStream "#{API_URL}/users/#{id}"
```

## Stylus <a class="anchor" name="best-practices_stylus"></a>

  - Namespace all components under `z-<component>`
  - Only use direct child selectors
  - If classing a deep child, its root with `z-<component>_<deep>`
  - all classes should be [kebab-case](https://lodash.com/docs#kebabCase) (except when namespacing)
  - use [z.classKebab()](/api/class-kebab) on the top-level element for state management
  - state classes should start with `is` or `has` (or similar)
  - state definitions should be blocked together

(Note to external component creators, use a different prefix from `z-`, e.g. `zp-` for [zorium-paper](https://github.com/Zorium/zorium-paper))

```coffee
class BigDrawer
  render: ->
    z '.z-big-drawer', # namespace
      className: z.classKebab { # state
        isRed: true
      }
      z '.blue',
        z '.pad', 'hello'
      z $button, {
        $content: z '.z-drawer_icon', # deep child
          className: z.classKebab {isRed: true} # state
          'click'
      }
```

```stylus
.z-big-drawer // namespace
  > .blue // direct children only
    background: blue

    > .pad
      padding: 20px

  &.is-red // state
    > .blue
      background: red

.z-big-drawer_icon // deep child
  background: blue

  &.is-red // state
    background: red
```

## CoffeeScript <a class="anchor" name="best-practices_coffee-script"></a>

  - Follow the Clay [CoffeeScript Style Guide](https://github.com/claydotio/coffeescript-style-guide)  
    - Use the `coffeelint.json` within the repo as well
    - Alternatively, install the Clay [Atom plugin](https://github.com/claydotio/linter-clay-coffeelint)
  - Always deconstruct `@state` and `params` before using (e.g. `{val} = @state.getValue()`)

## State Management <a class="anchor" name="best-practices_state-management"></a>

The way [z.router.factoryToMiddleware()](/server/factory-to-middleware) works is by creating a new
instance of the component returned by `factory()` for every request.  
This means that local state created in the app will propagate between requests if not properly cleared.

The strategy employed by [Zorium-Seed](/best-practices/zorium-seed) is to use a `StateService`,  
which is then cleard in the `factory()` method like so:

```coffee
StateService = require './services/state'

factory = ->
  StateService.clear()
  new App()
```

Other services (like the [request service](https://github.com/Zorium/zorium-seed/blob/master/src/services/request.coffee))
can then use the `StateService` for local state.

Another key note is that the server finishes rendering once all component `@state` values have settled

e.g. This will never return

```coffee
class Bad
  constructor: ->
    @state = z.state
      never: Rx.Observable.empty()
  render: ->
    z 'div', 'hi'
```

If your app instantiates all components at run-time (it may not render them),  
it is important that asyncronous network reuests are [cold](https://github.com/Reactive-Extensions/RxJS/blob/master/doc/gettingstarted/backpressure.md)

e.g.

```coffee
class Async
  constructor: ->
    @state = z.state
      async: Rx.Observable.defer -> # create a 'cold' observable
        Rx.Observable.fromPromise window.fetch('/model.json')
```

## Animation <a class="anchor" name="best-practices_animation"></a>

Animation state should be encoded in the component state

e.g.

```coffee
class Animate
  constructor: ->
    @state = z.state
      isAnimating: false
  render: =>
    {isAnimating} = @state.getValue()

    z 'button.z-animate',
      className: z.classKebab {isAnimating}
      onclick: =>
        @state.set isAnimating: true
        setTimeout =>
          @state.set isAnimating: false
        , 1000
      'click me'
```

```stylus
.z-animate
  width: 40px
  transition: width 1s

  &.is-animating
    width: 100px
```

## Naming <a class="anchor" name="best-practices_naming"></a>

  - prefix component instances with `$`, e.g. `$head = new Head()`
  - prefix DOM nodes with `$$`, e.g. `$$el = document.body`
  - postfix services with `Service` e.g. `MeService = require 'services/me'`
  - postfix pages with `Page` e.g. `MePage = require 'pages/me'`
  - Models and Components don't need a postfix
  - folders and files use [snake_case](http://en.wikipedia.org/wiki/Snake_case)
