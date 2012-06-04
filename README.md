soyer
===========

[![Build Status](https://secure.travis-ci.org/mpneuried/soyer.png?branch=master)](http://travis-ci.org/mpneuried/soyer)

**Soyer** is small lib for serverside use of Google Closure Templates with node.js.

Thanks to [Daniel Pupius](http://search.npmjs.org/#/_author/Daniel%20Pupius) for [soynode](http://search.npmjs.org/#/soynode). I used this module as template and added the language support and removed the compile features.

*Written in coffee-script*

**INFO: all examples are written in coffee-script**


## Install

```
  npm install soyer
```



### Initialize module:

first you have to define the connection and table attributes and get an instance of the simple-dynamo interface.

```
mySoyer = new Soyer( config )

mySoyer.load ( err, success )->
	if err
		throw err
	else
		console.log( "templates sucessfully loaded" )

```

####config object description

- **path** : *( `String` required )*  
absolute path to the directory where the module can find compiled soy files.
- **soyFileExt** : *( `String` optional: default = ".soy.js" )*  
soy file extension to select only the compiled soy files.
- **languagesupport** : *( `Boolean` optional: default = false )*  
enable the language support. If true the following options are relevant.
- **defaultlang** : *( `String` optional: default = "en-us" )*  
the default language code if the passed code will not fit.
- **availibleLangs** : *( `Array` optional: default = "[ "en-us", "de-de" ]" )*  
a list of valid language codes
- **extractLang** : *( `Function` optional )*  
a method to extract the language-code out of the filename. The filename will be passed to the method and should return a valid language code.

**Example**
```
Soyer = require( "soyer" )

mySoyer = new Soyer
	path: path.resolve( __dirname, "../path/to/templates/" ) 

mySoyer.load ( err, success )->
	throw err if err

	rendered = mySoyer.render( "myNamespace.myTemplate", { param1: "abc" } )
	console.log( rendered )
```

**Advanced example**
```
# files in folder: template.soy, template.en.js, template.fr.js, template.de.js

Soyer = require( "soyer" )

mySoyer = new Soyer
	path: path.resolve( __dirname, "../path/to/templates/" ) 
	soyFileExt: ".js"
	languagesupport: true
	defaultlang: "de"
	availibleLangs: [ "en", "de", "fr" ]
	extractLang: ( file )->
		[ _name, _lang ] = file.split( "." )
		return _lang


mySoyer.load ( err, success )->
	throw err if err

	renderedDE = mySoyer.render( "myNamespace.myTemplate", "de" { param1: "deutsch" } )
	console.log( renderedDE )

	renderedEN = mySoyer.render( "myNamespace.myTemplate", "en" { param1: "english" } )
	console.log( renderedEN )

	renderedFR = mySoyer.render( "myNamespace.myTemplate", "fr" { param1: "français" } )
	console.log( renderedFR )
```


## get a template method ( GET )

Get's a method to render a template.

**`mySoyer.get( name, [ lang ] )` Arguments** : 

- **name**: *( `String` required )*  
soy path of the template.  
- **lang**: *( `String` required )*  
the language to render if `languagesupport` is activated.  

**Example**
```
fnTemplate = mySoyer.get( "myNamespace.path.to.template" )

console.log( fnTemplate( { param1: "hello world" } ) )
```

## render a template ( RENDER )

render a template immediately

**`mySoyer.get( name, [ lang ] )` Arguments** : 

- **name**: *( `String` required )*  
soy path of the template.  
- **lang**: *( `String` optional )*  
the language to render if `languagesupport` is activated.  
- **data**: *( `String` optional: default = {} )*  
template data.  

**Example**
```
rendered = mySoyer.render( "myNamespace.path.to.template", { param1: "hello world" } )
console.log( rendered )
```


###General info

To define a locale my best practice is a combination of language-code `ISO 639` and country-code `ISO 3166`.  
But you can define your own logic with this module.