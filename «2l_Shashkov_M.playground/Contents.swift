import UIKit

var numbers:[Int] = []

//про уникальность значений не уточнялось, по этому использовал random
while numbers.count < 100 {
    numbers.append(Int.random(in: 0...100))
}

func bubbleSort ( array: inout [Int]) -> [Int] {
    var isSorted = false
    while !isSorted {
        isSorted = true
        for i in 0..<array.count - 1 {
            if array [i] > array [i+1] {
                array.swapAt(i, i+1)
                isSorted = false
            }
        }
    }
    return array
}

//функция определяющая четность числа
func odd (value:Int) -> Bool{
    var isOdd:Bool
    if value % 2 == 0{
        isOdd = true
    }else {
        isOdd = false
    }
    return isOdd
}

//функция определяющая деление на 3
func canBeDividedIntoThree (value:Int) -> Bool {
    var canBe:Bool
    if value % 3 == 0 {
        canBe = true
    }else {
        canBe = false
    }
    return canBe
}

bubbleSort(array: &numbers)
print(numbers,"\n")

//не получилось использовать собственные циклы с функциями выше (инфо ниже) по этому использовал метод removeAll
numbers.removeAll(where: {$0 % 2 != 0})
print (numbers,"\n")

numbers.removeAll(where: {$0 % 3 != 0})
print (numbers,"\n")


//На этом задачи вроде решил, но есть вопрос, почему возникает ошибка в данном цикле:

for i in 0..<numbers.count {
    if odd(value: numbers [i]) == false{
        //print (i) //выводит индекс массива, который,казалось бы, можно использовать для удаления
        numbers.remove(at: i) //ошибка здесь т.к. за индекс указана переменная i, но почему?
    }else {
        continue
    }
}

//Фибоначчи

var fib:[Int] = [0,1]
var i:Int = 2
while fib.count < 50 {
    let x:Int = fib[i - 2] + fib[i - 1]
    fib.append(x)
    i+=1
}
print (fib)
