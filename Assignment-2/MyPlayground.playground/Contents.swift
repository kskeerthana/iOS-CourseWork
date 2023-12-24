import UIKit

var greeting = "Hello, playground"

var age:Int = 24
var pi:Float = 3.14
var isTrue = false

let maxSpeed = 120
var currSpeed = maxSpeed - 20
currSpeed = maxSpeed/2;

var nums = [1,2,3,4,5,6,7,8,9,10]
nums.append(11)
nums.remove(at: 0)

var fruits = ["apple", "banana", "cherry"]
fruits.swapAt(1, 2)
print(fruits)

var numSet : Set = [1,2,3,4]
numSet.insert(5)
numSet.remove(2)
print(numSet)

var fruitDict = ["apple": "red",
                 "banana" : "yellow",
                 "cherry": "red"
]
fruitDict.updateValue("purple", forKey: "grape")
fruitDict.removeValue(forKey: "apple")
fruitDict.updateValue("green", forKey: "banana")
print(fruitDict)

var name : String? = "Optional"

if (name != nil ){
    print("Hello",(name))
}
else{
    print("No value")
}
if (name != nil ){
    print(name!)
}
else{
    print("No value")
}

var score : Int? = 67
let scoreCheck = score?.description;

let defaultScore = 13;
let optionalCheck = score??defaultScore
