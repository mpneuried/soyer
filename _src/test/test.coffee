_ = require("lodash")
path = require "path"
should = require('should')

Soyer = require("../lib/soyer/")

_Cnf = 
	path: path.resolve( __dirname, "./tmpls/" ) 
	pathLang: path.resolve( __dirname, "./tmplsLang/" ) 

describe 'SOYER-TEST', ->

	before ( done )->
		done()
		return

	after ( done )->
		done()
		return


	describe 'No language support', ->

		soyerInst = null

		it 'get a soyer instance', ( done )->
			soyerInst = new Soyer
				languagesupport: false
				path: _Cnf.path

			soyerInst.should.be.an.instanceOf Soyer

			done()
			return

		it 'load templates', ( done )->
			soyerInst.load ( err, success )->
				should.not.exist( err )
				success.should.be.ok
				done()
				return
			return

		it 'render a test template', ( done )->
			
			_renderd = soyerInst.render( "test.test1", {} )
			_renderd.should.equal( "Hello World" )
			done()
			
			return

		it 'render a test template with params', ( done )->
			
			_renderd = soyerInst.render( "test.test2", { name: "soyer" } )
			_renderd.should.equal( "Hello soyer" )
			done()
			
			return

		return

	describe 'With language support', ->
		
		soyerInst = null

		it 'get a soyer instance', ( done )->
			soyerInst = new Soyer
				languagesupport: true
				path: _Cnf.pathLang

			soyerInst.should.be.an.instanceOf Soyer

			done()
			return

		it 'load templates', ( done )->
			soyerInst.load ( err, success )->
				should.not.exist( err )
				success.should.be.ok
				done()
				return
			return

		it 'render a test template in english', ( done )->
			
			_renderd = soyerInst.render( "test.test1", "en-us", {} )
			_renderd.should.equal( "Hello World" )
			done()
			
			return

		it 'render a test template in german', ( done )->
			
			_renderd = soyerInst.render( "test.test1", "de-de", {} )
			_renderd.should.equal( "Hallo Welt" )
			done()
			
			return

		it 'render a test template with params in english', ( done )->
			
			_renderd = soyerInst.render( "test.test2", "en-us", { name: "soyer" } )
			_renderd.should.equal( "Hello soyer" )
			done()
			
			return

		it 'render a test template with params in german', ( done )->
			
			_renderd = soyerInst.render( "test.test2", "de-de", { name: "soyer" } )
			_renderd.should.equal( "Hallo soyer" )
			done()
			
			return

		return

	describe 'Helper Methods', ->

		_h = Soyer.helper


		it 'get language out of browser header-string `accepted-language`', ( done )->
			
			tests = 
				"en,fr-fr;q=0.8,fr;q=0.6,de-de;q=0.4,de;q=0.2": "en-us"
				"fr-fr;q=0.8": "en-us"
				"de": "de-de"
				"en": "en-us"
				"fr": "en-us"

			for _browserstring, res of tests
				_h.extractLanguage( _browserstring ).should.equal( res )

			done()

		it 'get language out of browser header-string `accepted-language` with different default', ( done )->
			
			tests = 
				"en,fr-fr;q=0.8,fr;q=0.6,de-de;q=0.4,de;q=0.2": "en-us"
				"fr-fr;q=0.8": "de-de"
				"de": "de-de"
				"en": "en-us"
				"fr": "de-de"

			_h.setDefaultLanguage( "de-de" )

			_h.getDefaultLanguage().should.equal( "de-de"  )

			for _browserstring, res of tests
				_h.extractLanguage( _browserstring ).should.equal( res )

			done()

		it 'get language out of browser header-string `accepted-language` with new language', ( done )->
			
			tests = 
				"en,fr-fr;q=0.8,fr;q=0.6,de-de;q=0.4,de;q=0.2": "en-us"
				"fr-fr;q=0.8": "fr-fr"
				"de": "de-de"
				"en": "en-us"
				"fr": "fr-fr"

			LangMapping = 
				"fr-fr": "fr-fr"
				"fr": "fr-fr"

			expLangMapping = 
				"de-de": "de-de"
				"de": "de-de"
				"en-us": "en-us"
				"en-gb": "en-us"
				"en": "en-us"
				"fr-fr": "fr-fr"
				"fr": "fr-fr"

			_h.setLanguageMapping( LangMapping )

			_h.getLanguageMapping().should.eql( expLangMapping )

			for _browserstring, res of tests
				_h.extractLanguage( _browserstring ).should.equal( res )

			done()

		it 'fail by setting a unknown default language', ( done )->
			try
				_h.setDefaultLanguage( "ab-cd" )
			catch e
				e.message.should.equal( "soyer-helper: Default language not found in `LanguageMapping`" )

			done()


	return