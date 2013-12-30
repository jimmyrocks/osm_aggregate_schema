/*jshint quotmark:false */

var fs = require('fs'),
settings = {
  "style": "default.style",
  "all": {
    "removeColumns": ["way_area", "z_order"],
    "flags": ["linear", "polygon", "road", "none"]
  },
  "views" : {
    "point": {
      "whereClause": "(tags != ''::hstore AND tags is not null)",
      "osmType": "node",
      "flags": ["linear", "polygon", "road"],
      "origTable": "nodes",
      "destTable": "points"
    },
    "line": {
      "whereClause": "(tags != ''::hstore AND tags is not null AND tags -> 'area' != '1' AND tags -> 'area' != 'yes')",
      "osmType": "way",
      "flags": ["linear", "polygon", "road"],
      "origTable": "ways",
      "destTable": "lines"
    },
    "road": {
      "whereColumns": ["minor",
        "road",
        "unclassified",
        "residential",
        "tertiary_link",
        "tertiary",
        "secondary_link",
        "secondary",
        "primary_link",
        "primary",
        "trunk_link",
        "trunk",
        "motorway_link",
        "motorway"],
      "whereClause": "(tags != ''::hstore AND tags is not null AND tags -> 'area' != '1' AND tags -> 'area' != 'yes')",
      "osmType": "way",
      "flags": ["road"],
      "origTable": "nodes",
      "destTable": "roads"
    },
    "polygon": {
      "whereClause": "(tags != ''::hstore AND tags is not null AND nodes[1] = nodes[array_length(nodes, 1)])",
      "osmType": "way",
      "flags": ["polygon"],
      "origTable": "ways",
      "destTable": "polygons"
    }
  }
},
readStyle = function(xSettings, style) {
  for (var line=0; line<style.length; line++) {
    if (style[line].length >= 3) {
      if (style[line].length === 3) {style[line].push("none");}
      for (var allFlag = 0; allFlag < xSettings.all.flags.length; allFlag++) {
        if (style[line][3] === xSettings.all.flags[allFlag]) {
          if (xSettings.column) {
            xSettings.column.push(style[line][1]);
          } else {
            xSettings.column = [style[line][1]];
          }
        }
      }
      for (var type in xSettings.views) {
        if (xSettings.views[type].osmType && style[line][0].indexOf(xSettings.views[type].osmType) > -1) {
          if (xSettings.views[type].flags) {
            for (var flag = 0; flag < xSettings.views[type].flags.length; flag++) {
              if (style[line][3] === xSettings.views[type].flags[flag]) {
                if (!xSettings.views[type].removeColumns) {xSettings.views[type].removeColumns = xSettings.all.removeColumns;}
                if (xSettings.views[type].removeColumns) {
                  for (var col = 0; col < xSettings.views[type].removeColumns.length; col++) {
                    if (xSettings.views[type].removeColumns[col] !== style[line][1]) {
                      if (xSettings.views[type].whereColumns) {
                        var exists = false;
                        for (var field = 0; field < xSettings.views[type].whereColumns.length; field++) {
                          if (xSettings.views[type].whereColumns[field] === style[line][1]) {
                            exists = true;
                          }
                        }
                        if (!exists) {
                          xSettings.views[type].whereColumns.push(style[line][1]);
                        }
                      } else {
                        xSettings.views[type].whereColumns = [style[line][1]];
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  return xSettings;
},
createViews = function(ySettings) {
  console.log(JSON.stringify(ySettings, null, 2));
},
readFile = function(path, callback) {
  var parsedFile, result = [];
  fs.readFile(path, 'utf8', function (err,data) {
    if (err) {
      return console.log(err);
    } else {
      parsedFile = data.split('\n');
      for (var i=0; i<parsedFile.length; i++) {
        parsedFile[i] = parsedFile[i].replace(/(^#.+|#.+|#)/g, '');
        parsedFile[i] = parsedFile[i].replace(/^\s+|\s+$/g,'');
        parsedFile[i] = parsedFile[i].replace(/\s+/g, ' ');
        if (parsedFile[i].length > 0) {
          result.push(parsedFile[i].split(' '));
        }
      }
      return callback(result);
    }
  });
};

readFile(settings.style, function(result) {createViews(readStyle(settings, result));});
