import UIKit

//Для простоты a,b,c указанны один раз для всех вычислений
var a:Double = 2
var b:Double = 8
var c:Double = 8

//Квадратное уравнение
func calculate (a:Double,b:Double,c:Double) -> Double{
    let D = pow(b,2) - 4*(a*c)
    return D
}
let example = calculate(a:a,b:b,c:c)

switch example {
case 0:
    let x1 = -b / (2*a)
    print ("Так как дискриминант равен нулю, квадратное уравнение имеет один корень. X= ", x1)
    break
case ..<0:
    print ("Так как дискриминант меньше нуля, уравнение не имеет решений")
    break
case 1...:
    let x1 = (-b + sqrt(example)) / (2*a)
    let x2 = (-b - sqrt(example)) / (2*a)
    print("Так как дискриминант больше нуля, квадратное уравнение имеет два корня. X1 = ",x1,"X2 = ",x2)
    break
default:
    print("все сломалось")
}

//Triangle

func S (a:Double, b:Double) -> Double {
    let s = (a*b)/2
    return s
}

let square :Double = S(a: a, b: b)

print("Площадь треугольника со сторонами a =",a,"и b =",b,"S = ",square)

func P (a:Double, b:Double, c:Double) -> Double {
    let p = a+b+c
    return p
}
let perimeter:Double = P(a:a,b:b,c:c)

print("Периметр треугольника=",perimeter)

func C (a:Double,b:Double) ->Double {
    let c = sqrt (pow(a,2)+pow(b,2))
    return c
}
let hypotenuse = C(a:a, b:b)
print("Гипотенуза треугольника=",hypotenuse)
