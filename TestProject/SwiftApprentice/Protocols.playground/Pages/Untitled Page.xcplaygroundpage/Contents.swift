//: Playground - noun: a place where people can play

import UIKit

// 创建一个协议，协议的方法不用实现，且方法不能设置访问控制
protocol Vehicle {
    func accelerate()
    func stop()
    // 在协议中，方法参数不允许有默认值
//    func turn(direction: String = "")
    // 在协议中创建的属性必须明确设置set, get，且和方法一样不需要实现
    var weight: Int { get }
    var name: String { get set }
}

// 继承协议写法,必须实现协议中的必选方法和属性，否则报错
class Unicycle: Vehicle {
    func accelerate() {
        
    }
    
    func stop() {
        
    }
    
    var weight: Int = 0
    var name: String = ""
}

// 协议也可以继承自另外的协议，和方法一样，当别的类遵循这个协议时，必须实现 WheeledVehicle 和 Vehicle 的所有必选方法和属性
protocol WheeledVehicle: Vehicle {
    var numberOfWheels: Int { get }
    var wheelSize: Double { get set }
}

protocol WhatType {
    var typeName: String { get }
}

// 扩展协议写法
extension WhatType {
    
}

extension String: WhatType {
    var typeName: String {
        return "a String"
    }
}

let myType: String = "Swift Apprentice!"
myType.typeName

struct Record {
    var wins: Int
    var losses: Int
}

let rA = Record(wins: 1, losses: 1)
let rB = Record(wins: 1, losses: 1)

//rA == rB
// 通过扩展让 Record 遵守 Equatable 协议，从而重载 == 操作符来比较两个结构体实例
extension Record: Equatable {}
func ==(lhs: Record, rhs: Record) -> Bool {
    return lhs.wins == rhs.wins && lhs.losses == rhs.losses
}

rA == rB

/********************* useful protocols *******************/
extension Record: Boolean {
    var boolValue: Bool {
        return wins > losses
    }
}
// 通过让 Record 遵循 Boolean 协议，可以判断布尔值
if Record(wins: 5, losses: 1) {
    print("Yes")
}
// 通过遵循 CustomStringConvertible 协议，自定义 log
extension Record: CustomStringConvertible {
    var description: String {
        return "\(wins) - \(losses)"
    }
}

print(rA)
