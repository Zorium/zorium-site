# Folder structure

```md
/src
  /components
  /models
  /pages
  /services
  root.coffee
/test
  /components
  /models
  ...
```

# root.coffee

This file serves as the initialization point for the application.  
Currently, routing goes here, along with other miscellaneous things.

# Components <a class="anchor" name="components"></a>

Components should set `@state` as a `z.state` when using local state
Components are classes of the form:

```coffee
module.exports = class MyAbc
  render: ->
    # define view
```

# Models <a class="anchor" name="models"></a>

Models are used for storing application state, as well as making resource API requests
Models are singletons of the form  

```coffee
class AbcModel
  # define model methods

module.exports = new AbcModel()
```

# Pages <a class="anchor" name="pages"></a>

Pages are components which are routed to via the router.  
They should contain as little logic as possible, and are responsible for laying out
components on the page.

```coffee
Nav = require('../components/nav')
Body = require('../components/body')

module.exports = class HomePage
  constructor: (params) ->
    @state = z.state
      $nav: new Nav()
      $body: new Body(params.key)

  render: =>
    {$nav, $body} = @state()
    z 'div',
      z $nav
      z $body
```

## Page Extension

If extending a root page with sub-pages is desired, subclass.

```coffee
Nav = require('../components/nav')
Footer = require('../components/footer')
OtherFooter = require('../components/otherFooter')

class RootPage
  constructor: ->
    @state = z.state
        $nav: new Nav()
        $footer: new Footer()

  render: =>
    {$nav, $footer} = @state()
    z 'div',
      z $nav
      z $footer

class APage extends RootPage
  constructor: ->
    super

    @state.set
      $footer: new OtherFooter()
```


# Services <a class="anchor" name="services"></a>

Services are singletons of the form

```coffee
class AbcService
  # define service methods

module.exports = new AbcService()
```
