//
//  Operator.swift
//  Kelvin
//
//  Created by Jiachen Ren on 11/9/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Foundation

typealias Bin = (Double, Double) throws -> Double

/**
 Binary operations such as +, -, *, /, etc.
 Supports definition of custom binary operations.
 */
class BinOperation: CustomStringConvertible {
    
    // Standard & custom binary operations
    static var registered: Dictionary<String, BinOperation> = [
        "+": .init("+", .third, +),
        "-": .init("-", .third, -),
        "*": .init("*", .second, *),
        "/": .init("/", .second, /),
        "^": .init("^", .first, pow),
        ">": .init(">", .first){$0 > $1 ? 1 : 0},
        "<": .init("<", .first){$0 < $1 ? 1 : 0},
        "%": .init("%", .second){$0.truncatingRemainder(dividingBy: $1)},
        ]
    
    
    var description: String {
        return name
    }
    
    var name: String
    var bin: Bin
    var priority: Priority
    
    private init(_ name: String, _ priority: Priority, _ bin: @escaping Bin) {
        self.priority = priority
        self.name = name;
        self.bin = bin
    }
    
    static func define(_ name: String, priority: Priority, bin: @escaping Bin) {
        let op = BinOperation(name, priority, bin)
        registered.updateValue(op, forKey: name)
    }
}

enum Priority: Int, Comparable {
    case first = 1
    case second = 2
    case third = 3
    
    static func < (lhs: Priority, rhs: Priority) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

typealias Unary = (Double) throws -> Double
class UnaryOperation {
    static var registered: Dictionary<String, Unary> = [
        "log": log10,
        "log2": log2,
        "ln": log,
        "int": {Double(Int($0))},
        "negate": {-$0}
    ]
}

func log10(_ a: Double) -> Double {
    return log(a) / log(10)
}
