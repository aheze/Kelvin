//
//  Probability+Supplier.swift
//  Kelvin
//
//  Created by Jiachen Ren on 10/1/19.
//  Copyright © 2019 Jiachen Ren. All rights reserved.
//

import Foundation

extension Probability: Supplier {
    /// Bridge with KAS
    static let exports: [Operation] = [
        // Random number generation
        .noArg(.random) {
            Float80.random(in: 0..<1)
        },
        .binary(.random, Value.self, Value.self) {(lb, ub) in
            if (lb.float80 > ub.float80) {
                throw ExecutionError.invalidRange(lowerBound: lb, upperBound: ub)
            }
            return Float80.random(in: lb.float80...ub.float80)
        },
        .binary(.randomInt, Int.self, Int.self) {(lb, ub) in
            if (lb >= ub) {
                throw ExecutionError.invalidRange(lowerBound: lb, upperBound: ub)
            }
            return Int.random(in: lb...ub)
        },
        .unary(.random, List.self) {
            $0.elements.randomElement()
        },

        // Combination and permutation
        .binary(.npr, Int.self, Int.self) {
            Probability.nPr($0.float80, $1.float80)
        },
        .binary(.npr, List.self, Int.self) {
            List(Probability.permutations(of: $0.elements, $1).map {List($0)})
        },
        .binary(.ncr, Int.self, Int.self) {
            Probability.nCr($0.float80, $1.float80)
        },
        .binary(.ncr, List.self, Int.self) {
            List(Probability.combinations(of: $0.elements, $1).map {List($0)})
        },

        // Factorial
        .unary(.factorial, Int.self) {
            Probability.factorial($0.float80)
        }
    ]
}
