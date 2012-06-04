// This file was automatically generated from test.soy.
// Please don't edit this file by hand.

if (typeof test == 'undefined') { var test = {}; }


test.test1 = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('Hallo Welt');
  return opt_sb ? '' : output.toString();
};


test.test2 = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('Hallo ', soy.$$escapeHtml(opt_data.name));
  return opt_sb ? '' : output.toString();
};
