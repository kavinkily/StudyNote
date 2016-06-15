//: Playground - noun: a place where people can play

import UIKit

// 枚举很适合用来分别各种错误类型
enum RollingError: ErrorType {
    case Doubles
    case OutOfFunding
}

var hasFunding = true

// throws 可以表示该函数可以抛出错误
func roll(firstDice: Int, secondDice: Int) throws {
    let error: RollingError
    
    if firstDice == secondDice && hasFunding {
        error = .Doubles
        hasFunding = false
        throw error
    }
}

// 利用以下代码可以捕捉错误
do {
    try roll(1, secondDice: 1)
    // 没有错误，继续执行代码，有错误就调到 catch
} catch RollingError.Doubles {
    // 处理错误
}
//try! 类似强制展开 不用处理错误 无错通行 有错崩溃
//try? 类似可选调用 无错通行 有错返回nil
