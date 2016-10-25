z = require 'zorium'
Rx = require 'rx-lite'

if window?
  require './index.styl'

module.exports = class Editor
  constructor: ({@$$source}) ->
    @evalSubject = new Rx.BehaviorSubject null
    @editor = null

    @state = z.state
      initialValue: @$$source.textContent
      $component: @evalSubject
      refresh: @evalSubject.flatMapLatest ($component) ->
        if $component?.state
          $component.state
        else
          Rx.Observable.return null

  afterMount: ($$el) =>
    coffeeResolve = -> null
    coffeePromise = new Promise (resolve) ->
      coffeeResolve = resolve

    CodeMirrorPromiseResolve = -> null
    CodeMirrorPromise = new Promise (resolve) ->
      CodeMirrorPromiseResolve = resolve

    require.ensure [
      '../../vendor/coffee-script.js'
      'codemirror'
      'codemirror/mode/coffeescript/coffeescript.js'
      'codemirror/keymap/sublime.js'
      'codemirror/lib/codemirror.css'
      'codemirror/theme/monokai.css'
    ], (require) ->
      coffeeResolve \
        require '../../vendor/coffee-script.js'
      CodeMirrorPromiseResolve require 'codemirror'
      require 'codemirror/mode/coffeescript/coffeescript.js'
      require 'codemirror/keymap/sublime.js'
      require 'codemirror/lib/codemirror.css'
      require 'codemirror/theme/monokai.css'

    Promise.all [
      coffeePromise
      CodeMirrorPromise
    ]
    .then ([coffee, CodeMirror]) =>
      @editor = CodeMirror.fromTextArea $$el.querySelector('textarea'), {
        lineNumbers: true
        mode: 'coffeescript'
        theme: 'monokai'
        keyMap: 'sublime'
        showCursorWhenSelecting: true
        viewportMargin: Infinity
        tabSize: 2
      }

      # replace $$source with editor
      $$el.style.minHeight = @$$source.offsetHeight + 'px'
      @editor.setSize(null, @$$source.offsetHeight)
      @$$source.style.display = 'none'

      @editor.on 'scroll', (editor) =>
        @editor.setSize(null, 'auto')

      evalCoffee = (raw) ->
        compiled = coffee.compile raw
        window.require = (source) ->
          switch source
            when 'zorium'
              require 'zorium'
            when 'zorium-paper/button'
              require 'zorium-paper/button'
            when 'rx-lite'
              require 'rx-lite'
            else
              throw new Error "Module not found #{source}"
        source = """
          (function() {
            var exports = {};
            var module = {exports: exports};
            #{compiled}
            return module.exports;
          })()
        """
        return eval(source)

      Component = evalCoffee @editor.getValue()
      @evalSubject.onNext new Component()
      @editor.on 'change', (editor, change) =>
        try
          Component = evalCoffee @editor.getValue()
          @evalSubject.onNext new Component()
        catch err
          console.error err


  beforeUnmount: =>
    if @editor
      $$rm = @editor.getWrapperElement()
      $$rm.parentElement.removeChild $$rm

  render: =>
    {$component, initialValue} = @state.getValue()

    z '.z-editor',
      z '.input',
        z 'textarea',
          value: initialValue
          style:
            display: 'none'
      z '.output',
        $component
