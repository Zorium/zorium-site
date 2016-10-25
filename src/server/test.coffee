flareGun = require 'flare-gun'

app = require './index'

flare = flareGun.express(app)

after ->
  flare.close()

describe 'server', ->
  it 'is healthy', ->
    flare
      .get '/healthcheck'
      .expect 200, {
        healthy: true
      }

  it 'pongs', ->
    flare
      .get '/ping'
      .expect 200, 'pong'

  it 'renders /', ->
    flare
      .get '/'
      .expect 200
