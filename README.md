soyer
===========

[![Build Status](https://secure.travis-ci.org/mpneuried/soyer.png?branch=master)](http://travis-ci.org/mpneuried/soyer)
[![Dependency Status](https://david-dm.org/mpneuried/soyer.png)](https://david-dm.org/mpneuried/soyer)
[![NPM version](https://badge.fury.io/js/soyer.png)](http://badge.fury.io/js/soyer)

**Soyer** is small lib for serverside use of Google Closure Templates with node.js.

[![NPM](https://nodei.co/npm/soyer.png?downloads=true&stars=true)](https://nodei.co/npm/soyer/)

Thanks to [Daniel Pupius](http://search.npmjs.org/#/_author/Daniel%20Pupius) for [soynode](http://search.npmjs.org/#/soynode). I used this module as template and added the language support and removed the compile features.


## Install

```sh
  npm install soyer
```

### Initialize module:


```js
var Soyer = require("soyer");
var mySoyer = new Soyer( config );

mySoyer.load( function( err, success ){
	if( err ){
		throw err
	} else {
		console.log( "templates sucessfully loaded" );
	}
});
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
```js
var Soyer = require( "soyer" );

var mySoyer = new Soyer({
	path: path.resolve( __dirname, "../path/to/templates/" ) 
});

mySoyer.load( function( err, success ){
	if( err ){
		throw err
	}

	var rendered = mySoyer.render( "myNamespace.myTemplate", { param1: "abc" } );
	console.log( rendered );
});
```

**Advanced example**
```js
// files in folder: template.soy, template.en.js, template.fr.js, template.de.js

var Soyer = require( "soyer" );

var mySoyer = new Soyer({
	path: path.resolve( __dirname, "../path/to/templates/" ) ,
	soyFileExt: ".js",
	languagesupport: true,
	defaultlang: "de",
	availibleLangs: [ "en", "de", "fr" ],
	extractLang: function( file ){
		var _lang = file.split( "." )[1]
		return _lang
	}
});


mySoyer.load( function( err, success ){
	if( err ){
		throw err
	}

	var renderedDE = mySoyer.render( "myNamespace.myTemplate", "de" { param1: "deutsch" } );
	console.log( renderedDE );

	var renderedEN = mySoyer.render( "myNamespace.myTemplate", "en" { param1: "english" } );
	console.log( renderedEN );

	var renderedFR = mySoyer.render( "myNamespace.myTemplate", "fr" { param1: "français" } );
	console.log( renderedFR );
});
```


## get a template method ( GET )

Get's a method to render a template.

**`mySoyer.get( name, [ lang ] )` Arguments** : 

- **name**: *( `String` required )*  
soy path of the template.  
- **lang**: *( `String` required )*  
the language to render if `languagesupport` is activated.  

**Example**
```js
var fnTemplate = mySoyer.get( "myNamespace.path.to.template" );

console.log( fnTemplate( { param1: "hello world" } ) );
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
```js
var rendered = mySoyer.render( "myNamespace.path.to.template", { param1: "hello world" } );
console.log( rendered );
```

## routing helper

usually you will use soyer within a routing framework like express.  
In this case the server has to finish the loading of the templates before the first `.render()` is called.  
So you can use the method `routingWait` to add a middleware and make sure the templates has been loaded until the first rendering starts.

To use it you just have to add and call the method `[ your soyer instance ].routingWait()` as middleware.  
Buff
This is designed to fit to express. But you can use it in other tools, too. You just have to make sure the last argument of your routing framework is the *next* method ( e.g. in express it's `( request, response, next )` ).

**Example**
```
Soyer = require("soyer");

var express = require("express");
var app = express.createServer();

var mySoyer = new Soyer( config );
mySoyer.load( function( err ){
	if( err ){
		throw err
	}
});

app.get( "/myroute/:id", mySoyer.routingWait(), function( req, res ){
	// do your stuff
});

app.listen()
```

###General info

To define a locale my best practice is a combination of language-code `ISO 639` and country-code `ISO 3166`.  
But you can define your own logic with this module.

## Release History

|Version|Date|Description|
|:--:|:--:|:--|
|v0.3.4|2015-04-14|Added try catch during vm context create; changed to a more modern develpoment env with grunt; Switched to lodash |
|v0.3.3|2014-10-30|Fixed bug in `routingWait` method|
|v0.3.1|2013-12-04|Fixed bug to ignore hidden files ( prefixed with a `.` )|
|v0.3.0|2013-03-04|Updated soyutils to version Dez. 2012|

[![NPM](https://nodei.co/npm-dl/soyer.png?months=6)](https://nodei.co/npm/soyer/)

## Other projects

|Name|Description|
|:--|:--|
|[**rsmq**](https://github.com/smrchy/rsmq)|A really simple message queue based on Redis|
|[**rsmq-worker**](https://github.com/mpneuried/rsmq-worker)|RSMQ helper to simply implement a worker around the message queue|
|[**redis-notifications**](https://github.com/mpneuried/redis-notifications)|A redis based notification engine. It implements the rsmq-worker to safely create notifications and recurring reports.|
|[**node-cache**](https://github.com/tcs-de/nodecache)|Simple and fast NodeJS internal caching. Node internal in memory cache like memcached.|
|[**redis-sessions**](https://github.com/smrchy/redis-sessions)|An advanced session store for NodeJS and Redis|
|[**obj-schema**](https://github.com/mpneuried/obj-schema)|Simple module to validate an object by a predefined schema|
|[**connect-redis-sessions**](https://github.com/mpneuried/connect-redis-sessions)|A connect or express middleware to simply use the [redis sessions](https://github.com/smrchy/redis-sessions). With [redis sessions](https://github.com/smrchy/redis-sessions) you can handle multiple sessions per user_id.|
|[**systemhealth**](https://github.com/mpneuried/systemhealth)|Node module to run simple custom checks for your machine or it's connections. It will use [redis-heartbeat](https://github.com/mpneuried/redis-heartbeat) to send the current state to redis.|
|[**task-queue-worker**](https://github.com/smrchy/task-queue-worker)|A powerful tool for background processing of tasks that are run by making standard http requests.|
|[**grunt-soy-compile**](https://github.com/mpneuried/grunt-soy-compile)|Compile Goggle Closure Templates ( SOY ) templates inclding the handling of XLIFF language files.|
|[**backlunr**](https://github.com/mpneuried/backlunr)|A solution to bring Backbone Collections together with the browser fulltext search engine Lunr.js|

## License 

(The MIT License)

Copyright (c) 2013 M. Peter

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.