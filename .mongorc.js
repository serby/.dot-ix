/* global db */

load('/Users/serby/.dot-ix/lodash.min.js')

function toCsv(objArray, headers = []) {
  const array = typeof objArray !== 'object' ? JSON.parse(objArray) : objArray
  const properties = Object.keys(array[0]).filter(
    value => headers.length === 0 || headers.includes(value)
  )
  let str = `${properties.map(value => `"${value}"`).join('\t')}` + '\r\n'

  return array.reduce((str, next) => {
    str += `${properties.map(value => `"${next[value]}"`).join('\t')}` + '\r\n'
    return str
  }, str)
}

db.getMongo()
  .getDBNames()
  .forEach(function(database) {
    if (/^_?test/.test(database))
      db.getMongo()
        .getDB(database)
        .dropDatabase()
  })

DBCollection.prototype.read = function(id) {
  return this.find({ _id: ObjectId(id) })
}

DBCollection.prototype.search = function(terms) {
  return this.find({ $text: { $search: terms } })
}

DBCollection.prototype.countDistinct = function(propertyName) {
  return this.aggregate([
    { $group: { _id: '$' + propertyName, count: { $sum: 1 } } }
  ])
}

function sortObject(obj, reverse) {
  var output = [],
    prop
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
  list.forEach(function(row) {
    print(row.value, row.key)
  })
}

var clock = {
  sortObject: sortObject,
  printArray: printArray,
  toCsv: toCsv
}
