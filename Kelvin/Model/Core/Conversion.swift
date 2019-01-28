//
//  Conversion.swift
//  Kelvin
//
//  Created by Jiachen Ren on 1/20/19.
//  Copyright © 2019 Jiachen Ren. All rights reserved.
//

import Foundation

let conversionOperations: [Operation] = [
    .unary("degrees", [.any]) {
        $0 / 180 * (try! Variable("pi"))
    },
    .unary("pct", [.any]) {
        $0 / 100
    },
    
    // TODO: Implement all possible type coersions.
    .binary("as", [.any, .var]) {
        let n = $1 as! Variable, c = $0
        guard let dt = DataType(rawValue: n.name) else {
            throw ExecutionError.invalidDT(n.name)
        }
        
        func bailOut() throws {
            throw ExecutionError.inconvertibleDT(from: "\(c)", to: dt.rawValue)
        }
        
        switch dt {
        case .list:
            if let list = List($0) {
                return list
            }
            try bailOut()
        case .vector:
            if let vec = Vector($0) {
                return vec
            }
            try bailOut()
        case .matrix:
            if let list = $0 as? ListProtocol {
                return try Matrix(list)
            }
            try bailOut()
        default:
            break
        }
    
        return nil
    }
]
