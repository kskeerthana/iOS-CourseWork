import UIKit
import Foundation

func isPrime(num : Int) -> Bool{
    if (num == 0 || num == 1){
        return false
    }
    for i in 2..<num{
        if (num % i) == 0{
            return false
        }
    }
    return true
        
}

isPrime(num: 6)

func stringReverse(sentence : String)-> String{
    let words = sentence.split(separator: " ");
    var result = ""
    for word in words.reversed(){
        result += "\(word) "
    }
    return result
}

stringReverse(sentence: "iOS dev");

func mergeSortedArrays(_ arrA: [Int], _ arrB: [Int]) -> [Int] {
    var mergedArray = [Int]()
    var aIndex = 0
    var bIndex = 0

    while aIndex < arrA.count && bIndex < arrB.count {
        if arrA[aIndex] < arrB[bIndex] {
            mergedArray.append(arrA[aIndex])
            aIndex += 1
        } else if arrA[aIndex] > arrB[bIndex] {
            mergedArray.append(arrB[bIndex])
            bIndex += 1
        } else {
            mergedArray.append(arrA[aIndex])
            aIndex += 1
            bIndex += 1
        }
    }

    while aIndex < arrA.count {
        mergedArray.append(arrA[aIndex])
        aIndex += 1
    }

    while bIndex < arrB.count {
        mergedArray.append(arrB[bIndex])
        bIndex += 1
    }

    return mergedArray
}

let arrayA = [1, 3, 5, 7]
let arrayB = [2, 4, 6, 8]
let merged = mergeSortedArrays(arrayA, arrayB)
print(merged)

struct Building{
    var address : String
    var numberOfFloors : Int
    var yearBuilt : Int
    var type : String
    
    mutating func changeAddress(newAddress: String){
        address = newAddress
    }
    
    mutating func changeYOB(newYOB : Int){
        yearBuilt = newYOB
    }
}

var myBuilding = Building(address:"3193 Washington Street", numberOfFloors: 5, yearBuilt: 2014, type: "Residential")

myBuilding.changeAddress(newAddress: "3200 JP")
myBuilding.changeYOB(newYOB: 2020)

print(myBuilding.self)

class Computer{
    func purpose(){
        
    }
    func priceRange(){
        
    }
}

class GamingComputer : Computer{
   
    override func purpose() {
        print("For gaming and high-performance tasks.")
    }
    
    override func priceRange() {
        print("$1500 to $5000")
    }
}

let myComputer = GamingComputer()
myComputer.priceRange()
myComputer.purpose()

func checkPasswordStrength(_ password: String) -> String {
    guard password.count >= 8 else {
        return "Weak password"
    }

    var containsLetters = false
    var containsNumbers = false

    for char in password {
        if char.isLetter {
            containsLetters = true
        } else if char.isNumber {
            containsNumbers = true
        }

        // Exit early if both letters and numbers are found
        if containsLetters && containsNumbers {
            break
        }
    }

    if containsLetters && containsNumbers {
        return "Strong password"
    } else {
        return "Moderate password"
    }
}

checkPasswordStrength("Thenkeet_07")

protocol EnergySource{
    func energyType() -> String
    func avgConsumption() -> String
    func totalConsumption(distance: Double) -> Double
}

class ElectricCar : EnergySource{
    private let averageD : Double
    
    init(averageD: Double) {
        self.averageD = averageD
    }
    
    func energyType() -> String {
        return "petrol"
    }
    
    func avgConsumption() -> String {
        return "\(averageD) liters per 100km"
    }
    
    func totalConsumption(distance: Double) -> Double {
        return distance * averageD
    }
}

class WindTurbine : EnergySource{
    private let averageD : Double
    
    init(averageD: Double) {
        self.averageD = averageD
    }
    
    func energyType() -> String {
        return "electric"
    }
    
    func avgConsumption() -> String {
        return "\(averageD) k Wh per 100km"
    }
    
    func totalConsumption(distance: Double) -> Double {
        return distance * averageD
    }
}

let myElectricCar = ElectricCar(averageD: 5.3)
let myWindTurbine = WindTurbine(averageD: 15.9)

print("\(myElectricCar.energyType()) car has an average consumption of \(myElectricCar.avgConsumption())")
print("Total consumption for 150km: \(myElectricCar.totalConsumption(distance: 150)) kWh")

enum PaymentMethod{
    case creditCard(String)
    case cash(Double)
    case bankTransfer(bankName:String, accNum: String)
}

let creditPayment = PaymentMethod.creditCard("1011 3045 6723 7689")
let cashPayment = PaymentMethod.cash(2345.0)
let bankPayment = PaymentMethod.bankTransfer(bankName: "Santander", accNum: "23456372521")

class Temperature{
    var valueInCelius : Double
    
    init(valueInCelius: Double) {
        self.valueInCelius = valueInCelius
    }
}

extension Temperature{
    func farenheitValue()-> Double{
        return valueInCelius * 9/5 + 32
    }
}

let temp = Temperature(valueInCelius: 35)
print("Temperature in Fahrenheit: \(temp.farenheitValue())")
