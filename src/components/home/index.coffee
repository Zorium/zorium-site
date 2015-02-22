z = require 'zorium'

Code = require '../code'
PrimaryButton = require '../primary_button'
SecondaryButton = require '../secondary_button'
Header = require '../header'
styles = require './index.styl'

module.exports = class Home
  constructor: ->
    styles.use()

    @state = z.state
      $code: new Code()
      $header: new Header()
      $downloadBtn: new PrimaryButton()
      $downloadSeedBtn: new SecondaryButton()

  render: =>
    {$code, $header, $downloadBtn, $downloadSeedBtn} = @state()

    z '.z-home',
      z $header, title: 'Zorium'
      z '.body',
        z '.title', 'Introduction'
        z '.content',
          z '.text',
            'Zorium is a CoffeeScript Web Framework. '
            'It uses '
            z 'a.a[href=https://github.com/webpack/webpack]', 'WebPack'
            ' and '
            z 'a.a[href=https://github.com/Matt-Esch/virtual-dom]',
              'Virtual-DOM'
            ' to provide component isolation and efficient rendering.'
            ' No magic, no JSX, no bullshit,
              just plain CoffeeScript'
            z '.buttons',
              z 'a[href=https://github.com/Zorium/zorium]',
                z $downloadBtn, text: 'github'
              z 'a[href=https://github.com/Zorium/zorium-seed]',
                z $downloadSeedBtn, text: 'seed'
        z '.title', 'A Simple Component'
        z '.content',
          z $code, code:
            '''
            z = require 'zorium'

            class HelloMessage
              render: ({name}) ->
                z 'div',
                  "Hello #\{name}"

            $hello = new HelloMessage()
            z.render document.body, z $hello, name: 'Zorium'
            '''
        z '.title', 'A Stateful Component'
        z '.content',
          z $code, code:
            '''
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
                  "Seconds Elapsed: #\{secondsElapsed}"

            z.render document.body, new Timer()
            '''
        z '.title', 'An Application'
        z '.content',
          z $code, code:
            '''
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
                    z 'input[type=submit]', value: "Add ##\{items.length + 1}"

            z.render document.body, new TodoApp()
            '''
