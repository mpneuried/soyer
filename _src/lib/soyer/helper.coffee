_ = require "lodash"

LangMapping = 
	"de-de": "de-de"
	"de": "de-de"
	"en-us": "en-us"
	"en-gb": "en-us"
	"en": "en-us"

defaultLanguage = "en-us"

module.exports = 
	_waitforTemplates: ( req, res, next )->
		if @templatesloaded
			next()
		else
			@once "templatesloaded", ->
				next()
		return

	resetLanguageMapping: ( _langMapping )->
		LangMapping = _langMapping
		return

	setLanguageMapping: ( _langMapping )->
		LangMapping = _.extend( LangMapping, _langMapping )
		return

	getLanguageMapping: ->
		LangMapping

	setDefaultLanguage: ( lang )->
		if lang in _.uniq( _.values( LangMapping ) )
			defaultLanguage = lang
		else
			throw new Error('soyer-helper: Default language not found in `LanguageMapping`')
		return

	getDefaultLanguage: ->
		defaultLanguage

	extractLanguage: ( langs )->
		_foundLang = @
		_maxPrio = -1
		_langs = langs?.toLowerCase()?.split( "," ) or []
		for lang in _langs
			[ code, prio ] = lang.split( ";" )
			if prio
				prio = parseFloat( prio.replace( "q=", "" ) )
			else 
				prio = 1
			if prio > _maxPrio and code in _.keys( LangMapping )
				_maxPrio = prio
				_foundLang = code
		
		LangMapping[ _foundLang ] or defaultLanguage