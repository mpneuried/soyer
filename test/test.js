// Generated by CoffeeScript 1.3.3
(function() {
  var Soyer, path, should, _, _Cnf;

  _ = require("underscore");

  path = require("path");

  should = require('should');

  Soyer = require("../lib/soyer/");

  _Cnf = {
    path: path.resolve(__dirname, "./tmpls/"),
    pathLang: path.resolve(__dirname, "./tmplsLang/")
  };

  describe('SOYER-TEST', function() {
    before(function(done) {
      done();
    });
    after(function(done) {
      done();
    });
    describe('No language support', function() {
      var soyerInst;
      soyerInst = null;
      it('get a soyer instance', function(done) {
        soyerInst = new Soyer({
          languagesupport: false,
          path: _Cnf.path
        });
        soyerInst.should.be.an.instanceOf(Soyer);
        done();
      });
      it('load templates', function(done) {
        soyerInst.load(function(err, success) {
          should.not.exist(err);
          success.should.be.ok;
          done();
        });
      });
      it('render a test template', function(done) {
        var _renderd;
        _renderd = soyerInst.render("test.test1", {});
        _renderd.should.equal("Hello World");
        done();
      });
      it('render a test template with params', function(done) {
        var _renderd;
        _renderd = soyerInst.render("test.test2", {
          name: "soyer"
        });
        _renderd.should.equal("Hello soyer");
        done();
      });
    });
    describe('With language support', function() {
      var soyerInst;
      soyerInst = null;
      it('get a soyer instance', function(done) {
        soyerInst = new Soyer({
          languagesupport: true,
          path: _Cnf.pathLang
        });
        soyerInst.should.be.an.instanceOf(Soyer);
        done();
      });
      it('load templates', function(done) {
        soyerInst.load(function(err, success) {
          should.not.exist(err);
          success.should.be.ok;
          done();
        });
      });
      it('render a test template in english', function(done) {
        var _renderd;
        _renderd = soyerInst.render("test.test1", "en-us", {});
        _renderd.should.equal("Hello World");
        done();
      });
      it('render a test template in german', function(done) {
        var _renderd;
        _renderd = soyerInst.render("test.test1", "de-de", {});
        _renderd.should.equal("Hallo Welt");
        done();
      });
      it('render a test template with params in english', function(done) {
        var _renderd;
        _renderd = soyerInst.render("test.test2", "en-us", {
          name: "soyer"
        });
        _renderd.should.equal("Hello soyer");
        done();
      });
      it('render a test template with params in german', function(done) {
        var _renderd;
        _renderd = soyerInst.render("test.test2", "de-de", {
          name: "soyer"
        });
        _renderd.should.equal("Hallo soyer");
        done();
      });
    });
    describe('Helper Methods', function() {
      var _h;
      _h = Soyer.helper;
      it('get language out of browser header-string `accepted-language`', function(done) {
        var res, tests, _browserstring;
        tests = {
          "en,fr-fr;q=0.8,fr;q=0.6,de-de;q=0.4,de;q=0.2": "en-us",
          "fr-fr;q=0.8": "en-us",
          "de": "de-de",
          "en": "en-us",
          "fr": "en-us"
        };
        for (_browserstring in tests) {
          res = tests[_browserstring];
          _h.extractLanguage(_browserstring).should.equal(res);
        }
        return done();
      });
      it('get language out of browser header-string `accepted-language` with different default', function(done) {
        var res, tests, _browserstring;
        tests = {
          "en,fr-fr;q=0.8,fr;q=0.6,de-de;q=0.4,de;q=0.2": "en-us",
          "fr-fr;q=0.8": "de-de",
          "de": "de-de",
          "en": "en-us",
          "fr": "de-de"
        };
        _h.setDefaultLanguage("de-de");
        _h.getDefaultLanguage().should.equal("de-de");
        for (_browserstring in tests) {
          res = tests[_browserstring];
          _h.extractLanguage(_browserstring).should.equal(res);
        }
        return done();
      });
      it('get language out of browser header-string `accepted-language` with new language', function(done) {
        var LangMapping, expLangMapping, res, tests, _browserstring;
        tests = {
          "en,fr-fr;q=0.8,fr;q=0.6,de-de;q=0.4,de;q=0.2": "en-us",
          "fr-fr;q=0.8": "fr-fr",
          "de": "de-de",
          "en": "en-us",
          "fr": "fr-fr"
        };
        LangMapping = {
          "fr-fr": "fr-fr",
          "fr": "fr-fr"
        };
        expLangMapping = {
          "de-de": "de-de",
          "de": "de-de",
          "en-us": "en-us",
          "en-gb": "en-us",
          "en": "en-us",
          "fr-fr": "fr-fr",
          "fr": "fr-fr"
        };
        _h.setLanguageMapping(LangMapping);
        _h.getLanguageMapping().should.eql(expLangMapping);
        for (_browserstring in tests) {
          res = tests[_browserstring];
          _h.extractLanguage(_browserstring).should.equal(res);
        }
        return done();
      });
      return it('fail by setting a unknown default language', function(done) {
        try {
          _h.setDefaultLanguage("ab-cd");
        } catch (e) {
          e.message.should.equal("soyer-helper: Default language not found in `LanguageMapping`");
        }
        return done();
      });
    });
  });

}).call(this);
