# The Functional Reactive CoffeeScript Web <a class="anchor" name="intro"></a>

(╯°□°)╯︵ ┻━┻  
v1.0.0-rc17

## Features <a class="anchor" name="intro_features"></a>

  - First Class [RxJS Observables](https://github.com/Reactive-Extensions/RxJS)
  - Built for Isomorphism (server-side rendering)
  - Fast! - [virtual-dom](http://vdom-benchmark.github.io/vdom-benchmark/)
  - Standardized [Best Practices](/best-practices)
  - [Material Design Components](/paper)
  - Production-ready [Seed Project](https://github.com/Zorium/zorium-seed)
  - It's just CoffeeScript, no magic

## Example <a class="anchor" name="intro_example"></a>

```coffee
z = require 'zorium'

class AppComponent
  constructor: ->
    @state = z.state
      name: 'Zorium'

  render: =>
    {name} = @state.getValue()

    z '.zorium',
      z 'p.text',
        "The Future -#{name}"

z.render document.body, new AppComponent()
```

## Installation <a class="anchor" name="intro_installation"></a>

```bash
npm install --save zorium
```

## Contribute <a class="anchor" name="intro_contribute"></a>

```bash
npm install
npm test
```

Documentation -  [zorium-site](https://github.com/Zorium/zorium-site)

IRC: `#zorium` - chat.freenode.net
