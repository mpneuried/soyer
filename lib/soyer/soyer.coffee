vm = require "vm"
fs = require "fs"
path = require "path"
_ = require "underscore"
EventEmitter = require( "events" ).EventEmitter

regexLocal = /[a-zA-Z]{2}-[a-zA-Z]{2}$/i

module.exports = class ServerSoy extends EventEmitter 

	settingDefaults:
		path: "../templates"
		defaultlang: "en-us"
		availibleLangs: [ "en-us", "de-de" ]
		languagesupport: false
		soyUtilsPath: path.join(__dirname, '.', 'soyutils.js')
		soyFileExt: ".soy.js" 
		extractLang: ( file )->
			_res = regexLocal.exec( file )
			if _res and @config.languagesupport
				( _res[ 0 ] ).toLowerCase()
			else
				"global"

	constructor: ( settings = {} )->

		@globals = {}

		@ready = false

		@__defineGetter__ "config", =>
			_cnf = _.extend( {}, @settingDefaults, settings )
			_cnf.path = path.normalize( _cnf.path ) + "/"
			if not _cnf.languagesupport
				_cnf.defaultlang = "global"
			_cnf

		return

	load: ( cb )=>
		@_loadCompiledTemplates ( err, success )=>
			if err
				cb( err )
			else
				@emit( "ready" )
				@ready = true
				cb( null, true )
		return

	get: ( _n, lang = @config.defaultlang )=>
		if @ready
			lang = "global" if not @config.languagesupport
			parts = _n.toLowerCase().split('.')
			template = @_getLangGlobal( lang )

			while parts.length and template
				template = template[ parts.shift() ]

			if not template
				throw new Error('soyer: Unknown template [' + _n + ']')
		else
			throw new Error('soyer: module not loaded. Please run `.load()` first.')

		template

	render: ( _n, lang, data = {} )=>
		if @ready
			if arguments.length is 1
				data = {}
				lang = @config.defaultlang

			if arguments.length is 2
				data = lang
				lang = @config.defaultlang

			fn = @get( _n, lang )
			if fn 
				return fn( data )
			else
				throw new Error('soyer: Unknown template [' + _n + ']')
				return
		else
			throw new Error('soyer: module not loaded. Please run `.load()` first.')
			return

	routingWait: ->
		[ args... , next ] = arguments
		if @ready
			next()
		else
			@once "ready", ->
				next()
		return

	_loadCompiledTemplates: ( cb )=>
		_cnf = @config
		@_findFiles _cnf.path, _cnf.soyFileExt, (err, files)=>
			if err
				cb( err )
			else
				files = files.map( (file)-> path.join( _cnf.path, file ) )
				@_loadCompiledTemplateFiles( files, cb )
			return
		return

	_loadCompiledTemplateFiles: ( files, cb )=>

		next = ()=>
			if files.length is 0
				for lang, _vm of @contexts
					@_mixinGlobal( lang, _vm )
				cb(null, true)
			else
				_path = files.pop()
				_filename = path.basename( _path, @config.soyFileExt )
				_lang = if @config.languagesupport then @config.extractLang.call( @, _filename ) else "global"
				fs.readFile _path, 'utf8', (err, fileContents)=>
					if err 
						cb( err )
					else
						_vm = @_getContext( _lang )
						vm.runInContext(fileContents, _vm, _path)
						next()
					return
			return

		next()
		return

	_getContext: ( lang )=>
		@contexts or= {}

		if @contexts[ lang ]
			@contexts[ lang ]
		else
			_vm = vm.createContext({})

			vm.runInNewContext(fs.readFileSync( @config.soyUtilsPath, 'utf8'), _vm, @config.soyUtilsPath )
			@contexts[ lang ] = _vm
			_vm

	

	_getLangGlobal: ( lang )=>
		if lang in @config.availibleLangs and @globals[ lang ]
			@globals[ lang ]
		else if @globals[ @config.defaultlang ]
			@globals[ @config.defaultlang ]
		else
			_lang = _.first( _.keys( @globals ) )
			if _lang
				@globals[ _lang ]
			else
				null

	_mixinGlobal: ( lang, cntx )=>
		@globals[ lang ] or= {}
		for _n, _v of cntx
			@globals[ lang ][ _n ] = _v

		return

	_findFiles: ( directory, extension, cb )=>

		_cnf = @config

		files = []
		stack = [ directory ]
		_ext = @config.soyFileExt
		next = =>
			if not stack.length
				cb( null, files )
			else
				dir = stack.pop()
				fs.stat dir, (err, stats)=>
					if err
						cb( err )
					else

						return next() unless stats.isDirectory

						fs.readdir dir, ( err, dirContents )=>
							if err
								cb( err )
							else
								for file in dirContents
									fullpath = path.join(dir, file)
									if file[ 0 ] isnt "." and file.indexOf( _ext ) >= 0
										files.push( path.relative( directory, fullpath ) )
									else if file[ 0 ] isnt "." and file.indexOf( "." ) is -1
										stack.push( fullpath )
								next()
							return
					return
		next()
		return


