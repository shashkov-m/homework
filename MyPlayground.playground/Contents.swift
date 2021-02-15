import UIKit

protocol Car {
    var model:String {get}
    var year:Int {get}
    var maxSpeed:Int {get}
    var engineType:EngineType {get}
    var statusEngine:Bool {get set}
    
}
enum EngineType {
    case petrol,diesel,electric
}
enum Colour {
    case black, white, green, red, blue
}
extension Car {
    mutating func switchEngine () {
        self.statusEngine.toggle()
        print("Engine has been turned \(self.statusEngine ? "on" : "off")")
    }
}
class TruckCar:Car {
    let model:String
    let year:Int
    let maxSpeed:Int
    let engineType:EngineType
    var statusEngine:Bool
    let trunkVolume:Int
    
    init(model: String, year: Int, maxSpeed: Int, engineType: EngineType, statusEngine: Bool, trunkVolume: Int) {
        self.model = model
        self.year = year
        self.maxSpeed = maxSpeed
        self.engineType = engineType
        self.statusEngine = statusEngine
        self.trunkVolume = trunkVolume
        
    }
    
}

class SportCar:Car {
    let model: String
    let year: Int
    let maxSpeed: Int
    let engineType: EngineType
    var statusEngine: Bool
    let cabrio:Bool
    var colour:Colour
    
    init(model: String, year: Int, maxSpeed: Int, engineType: EngineType, statusEngine: Bool, cabrio: Bool, colour: Colour) {
        self.model = model
        self.year = year
        self.engineType = engineType
        self.statusEngine = statusEngine
        self.cabrio = cabrio
        self.colour = colour
        self.maxSpeed = maxSpeed
    }
}

extension TruckCar:CustomStringConvertible {
    var description: String {
        """
----------------------------------
Model: \(model)
Year: \(year)
Max speed: \(maxSpeed)
Engine type: \(engineType)
Engine is: \(statusEngine ? "on" : "off")
Trunk volume: \(trunkVolume)
"""
    }
    
    
}

extension SportCar:CustomStringConvertible {
    var description: String {
        """
----------------------------------
Model: \(model)
Year: \(year)
Max speed: \(maxSpeed)
Engine type: \(engineType)
Engine is: \(statusEngine ? "on" : "off")
Is it cabrio?: \(cabrio ? "yes" : "no")
Car colour: \(colour)
"""
    }
}
var truck = TruckCar (model: "Ford", year: 1990, maxSpeed: 160, engineType: .diesel, statusEngine: true, trunkVolume: 3900)
var sportCar = SportCar (model: "Tesla", year: 2016, maxSpeed:240, engineType: .electric, statusEngine: true, cabrio: true, colour: .black)
truck.switchEngine()
truck.switchEngine()
print (truck)
print (sportCar)

var truck1 = TruckCar (model: "Volvo", year: 2001, maxSpeed: 180, engineType: .petrol, statusEngine: true, trunkVolume: 4000)
var sportCar1 = SportCar (model: "BMW", year: 2012, maxSpeed: 260, engineType: .petrol, statusEngine: false, cabrio: false, colour: .red)
sportCar1.colour = .blue
truck1.switchEngine()
print(truck1)
print(sportCar1)

//MARK: PART 2

struct Queue<T: Car> {
    private var objects:[T] = []
    mutating func add (_ object: T) {
        objects.append(object)
    }
    
    mutating func delete () -> T? {
        guard objects.count > 0 else { return nil }
        return objects.removeFirst()
    }
    
    func lenght () -> Int {
        return objects.count
    }
    func random () -> T? {
        return objects.randomElement()
    }
    
    
}

var TruckQueue = Queue <TruckCar>()
var SportCarQueue = Queue <SportCar>()
TruckQueue.add(truck)
SportCarQueue.add(sportCar)
SportCarQueue.add(sportCar1)
TruckQueue.add(truck1)

TruckQueue.delete()
SportCarQueue.random()

print (SportCarQueue.lenght())

extension Queue {
    subscript (index: Int) -> String {
        guard index < objects.count else { return "Car not found" }
        return objects[index].model
    }
}

print(SportCarQueue [0])
print(TruckQueue [5])
