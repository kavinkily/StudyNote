//: Playground - noun: a place where people can play

import UIKit

protocol TeamRecord {
    var wins: Int { get }
    var losses: Int { get }
    func winningPercentage() -> Double
}

// 协议扩展和协议本身最大的不同就是协议成员有实现了
extension TeamRecord {
    var gamesPlayed: Int {
        return wins + losses
    }
}

protocol PlayoffEligible {
    var minimumWinsForPlayoffs: Int { get }
}

// 以下代码意思为当继承TeamRecord 和 PlayoffEligible协议以后才能使用该扩展
extension TeamRecord where Self: PlayoffEligible{
    func isPlayoffEligible() -> Bool {
        return self.wins > minimumWinsForPlayoffs
    }
}