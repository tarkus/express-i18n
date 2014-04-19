_ = require 'underscore'

options =
  lang: "en"
  locales: {}

captalize = (str) ->
  (str.split('_').map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join ' '

exports.chose = chose = (lang) ->
  (name, args={}) -> translate(lang, name, args)

translate = (lang, name, args={}) ->
  translation = options.locales[lang]
  parts = name.split(".")
  for part in parts
    continue if part is ""
    break unless translation[part]?
    translation = translation[part]

  unless typeof translation is "string"
    if process.env.NODE_ENV is "production"
      return "#{captalize(part)}"
    else
      return """<span class="translation_missing" ref="#{lang}.#{name}">#{captalize(part)}</span>"""

  for v,k in args
    translation = translation.replace(new RegExp("%{#{k}}", "g"), v)
    
  translation

exports.locales = -> options.locales

exports.connect = (opts) ->
  options = _.extend options, opts
  (req, res, next) ->
    res.locals.lang ?= options.lang
    res.language = (lang) -> res.locals.t = chose lang
    res.language res.locals.lang
    next()

