should  = require 'should'
express = require 'express'
request = require 'request'

i18n = require '../lib'

describe 'Express I18n', ->

  before (done) ->
    app = express()
    app.set 'view engine', "jade"
    app.set 'views', "#{__dirname}"

    app.use i18n.connect
      locales:
        en: require "#{__dirname}/locales/en"
        cn: require "#{__dirname}/locales/cn"

    app.get "/", (req, res, next) ->
      res.render 'layout'

    app.get "/cn", (req, res, next) ->
      res.language 'cn'
      res.render 'layout'

    app.listen(23456)

    done()

  it 'should translate phrase into default language', (done) ->
    request "http://localhost:23456", (error, response, body) ->
      body.should.match /Test/
      done()

  it 'should translate phrase into specified language', (done) ->
    request "http://localhost:23456/cn", (error, response, body) ->
      body.should.match /测试/

      done()
