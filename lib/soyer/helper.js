// Generated by CoffeeScript 1.3.3
(function() {
  var LangMapping, defaultLanguage, _,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  _ = require("underscore");

  LangMapping = {
    "de-de": "de-de",
    "de": "de-de",
    "en-us": "en-us",
    "en-gb": "en-us",
    "en": "en-us"
  };

  defaultLanguage = "en-us";

  module.exports = {
    _waitforTemplates: function(req, res, next) {
      if (this.templatesloaded) {
        next();
      } else {
        this.once("templatesloaded", function() {
          return next();
        });
      }
    },
    resetLanguageMapping: function(_langMapping) {
      LangMapping = _langMapping;
    },
    setLanguageMapping: function(_langMapping) {
      LangMapping = _.extend(LangMapping, _langMapping);
    },
    getLanguageMapping: function() {
      return LangMapping;
    },
    setDefaultLanguage: function(lang) {
      if (__indexOf.call(_.uniq(_.values(LangMapping)), lang) >= 0) {
        defaultLanguage = lang;
      } else {
        throw new Error('soyer-helper: Default language not found in `LanguageMapping`');
      }
    },
    getDefaultLanguage: function() {
      return defaultLanguage;
    },
    extractLanguage: function(langs) {
      var code, lang, prio, _foundLang, _i, _langs, _len, _maxPrio, _ref, _ref1;
      _foundLang = this;
      _maxPrio = -1;
      _langs = (langs != null ? (_ref = langs.toLowerCase()) != null ? _ref.split(",") : void 0 : void 0) || [];
      for (_i = 0, _len = _langs.length; _i < _len; _i++) {
        lang = _langs[_i];
        _ref1 = lang.split(";"), code = _ref1[0], prio = _ref1[1];
        if (prio) {
          prio = parseFloat(prio.replace("q=", ""));
        } else {
          prio = 1;
        }
        if (prio > _maxPrio && __indexOf.call(_.keys(LangMapping), code) >= 0) {
          _maxPrio = prio;
          _foundLang = code;
        }
      }
      return LangMapping[_foundLang] || defaultLanguage;
    }
  };

}).call(this);