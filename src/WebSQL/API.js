'use strict';

exports.openDatabase = function(name, version, displayName, estimatedSize, creationCallback) {
  return openDatabase(name, version, displayName, estimatedSize, creationCallback);
}
