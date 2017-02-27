/* global db */

db.getMongo().getDBNames().forEach(function(database) {
	if (/^_?test/.test(database)) db.getMongo().getDB(database).dropDatabase()
})

DBCollection.prototype.read = function (id) {
  return this.find({ _id: ObjectId(id) })
}

function countDistinct(collectionName, propertyName) {
	db[collectionName].aggregate([{ $group: { _id: '$' + propertyName}  },{ $group: { _id: 1, count: { $sum: 1 } } } ])
}

function sortObject(obj, reverse) {
  var output = []
  	, prop
  for (prop in obj) {
    if (obj.hasOwnProperty(prop)) {
    	output.push({ key: prop, value: obj[prop] })
    }
  }
  if (reverse) {
  	output.sort(function(a, b) {
  		return b.value - a.value
  	})
  } else {
  	output.sort(function(a, b) {
  		return a.value - b.value
  	})
  }
  return output
}

function printArray(list) {
	list.forEach(function (row) {
		print(row.value, row.key)
	})
}

var clock =
	{ countDistinct: countDistinct
	, sortObject: sortObject
	, printArray: printArray
	}
