import UIKit

//The map(_:) function loops over every item in a collection, and applies an operation to each element in the collection. It returns a collection of resulting items, to which the operation was applied.


var greeting = "Hello, playground"
let celsius = [-5.0, 10.0, 21.0, 33.0, 50.0]
let fahrenheit = celsius.map{ $0 * (9/5) + 32 }
print(fahrenheit)



//The reduce() method iterates over all items in array, combining them together somehow until you end up with a single value.

let names = ["Taylor", "Paul", "Adele"]
let count = names.reduce(0) { $0 + $1.count }
print(count)


//The filter function loops over every item in a collection, and returns a collection containing only items that satisfy an include condition.

let values = [11, 13, 14, 6, 17, 21, 33, 22]
let even = values.filter { $0.isMultiple(of: 2) }
print(even)
