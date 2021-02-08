import UIKit

enum EngineCondition {
    case on, off
}
enum WindowsState {
    case open, closed
}

struct SportCar  {
    let model = "BMW"
    let year = 2020
    let trunkVolume = 450
    var insideTrunk: Int
    var engine: EngineCondition
    var windows: WindowsState
    
    func about () {
        print ("**********************************************************")
        print ("Model: \(model)\nYear: \(year)\nTrunk Volume: \(trunkVolume)\nInside trunk: \(insideTrunk)\nEngine is \(engine)\nWindows are \(windows)")
    }
    
    mutating func EngineToggle (t: EngineCondition) {
        return engine = t
    }
}

struct Truck {
    let model = "Volvo"
    let year = 2021
    let trunkVolume = 4500
    var insideTrunk: Int
    var engine: EngineCondition
    var windows: WindowsState
    
    func about () {
        print ("**********************************************************")
        print ("Model: \(model)\nYear: \(year)\nTrunk Volume: \(trunkVolume)\nInside trunk: \(insideTrunk)\nEngine is \(engine)\nWindows are \(windows)")
    }
    
    mutating func putInTrunk (S: Int) {
        if S <= trunkVolume - insideTrunk {
            insideTrunk = insideTrunk + S
            print ("Done. \(S) inside, \(trunkVolume - insideTrunk) empty space left")
        } else {
            print ("\(S) is too much, trunk capacity is \(trunkVolume) and \(insideTrunk) already inside, try less number")
        }
    }
}
var myTruck = Truck (insideTrunk: 0, engine: .on, windows: .open)
myTruck.windows = WindowsState.closed
myTruck.putInTrunk(S: 2000)
myTruck.putInTrunk(S: 4000)
myTruck.about()

var mySummerCar = SportCar (insideTrunk: 0, engine: .off, windows: .open)
mySummerCar.EngineToggle(t: .on)
mySummerCar.about()

enum CarEngineType{
    case diesel, petrol, electric
}

// MARK: PART 2

class Car {
    let model: String
    let trunkVolume: Int
    let engineType: CarEngineType
    let plateNumber: String?
    var engineCondition: EngineCondition
    
    init (model: String, trunkVolume: Int, engineType: CarEngineType, plateNumber: String?, engineCondition: EngineCondition) {
        self.model = model
        self.trunkVolume = trunkVolume
        self.engineType = engineType
        self.plateNumber = plateNumber
        self.engineCondition = engineCondition
        
    }
    func refuel () {
        print ("tank is full")
    }
    
    func about () {
        print ("**********************************************************")
        print ("Model: \(model)\nTrunk Volume: \(trunkVolume)\nEngine type: \(engineType)\nEngine is \(engineCondition)\nPlate number: \(plateNumber ?? "001")")
    }
}

class TruckCar: Car {
    let height: Int
    init (model: String, trunkVolume: Int, engineType: CarEngineType, plateNumber: String?, engineCondition: EngineCondition, height:Int){
        self.height = height
        super.init (model: model, trunkVolume: trunkVolume, engineType: engineType, plateNumber: plateNumber, engineCondition: engineCondition)
    }
    
    override func refuel () {
        switch engineType {
        case .diesel :
            print ("diesel selected")
        case .petrol :
            print ("petrol selected")
        case .electric :
            print ("electricity selected")
            
        }
    }
    
    override func about () {
        super.about ()
        print ("Heigh: \(height)")
    }
    
}

class ElectricCar: Car {
    var batteryCapacity: Int
    init (model: String, trunkVolume: Int, engineType: CarEngineType = .electric, plateNumber: String?, engineCondition: EngineCondition, batteryCapacity:Int) {
        self.batteryCapacity = batteryCapacity
        super.init (model: model, trunkVolume: trunkVolume, engineType: .electric, plateNumber: plateNumber, engineCondition: engineCondition)
    }
    override func about () {
        super.about ()
        print ("Battery capacity: \(batteryCapacity)")
    }
}

var firstTruck = TruckCar (model: "Ford", trunkVolume: 3100, engineType: .diesel, plateNumber:nil, engineCondition: .off, height: 150)
firstTruck.refuel ()
firstTruck.about ()
var firstElectricCar = ElectricCar (model: "Tesla", trunkVolume: 360, plateNumber: "P700", engineCondition: .on, batteryCapacity: 18000)
firstElectricCar.engineCondition = .off
firstElectricCar.about ()
