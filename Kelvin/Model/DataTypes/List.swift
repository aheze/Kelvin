//
//  List.swift
//  Kelvin
//
//  Created by Jiachen Ren on 11/10/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Foundation

public struct List: MutableListProtocol, NaN {

    var elements: [Node]

    public var stringified: String {
        let pars = elements.map {
            $0.stringified
        }.reduce(nil) {
            $0 == nil ? "\($1)" : "\($0!), \($1)"
        }
        return "{\(pars ?? "")}"
    }

    init(_ elements: [Node]) {
        self.elements = elements
    }

    init(_ elements: Node...) {
        self.init(elements)
    }

    /// The ordering of the list does not matter, i.e. {1,2,3} is considered
    /// the same as {3,2,1}.
    /// - Returns: Whether the provided node is loosely identical to self.
    public func equals(_ node: Node) -> Bool {
        if let l = node as? List {
            return ordered().equals(list: l.ordered() as ListProtocol)
        }
        return false
    }
    
    /**
     Combine this list with another that has the same dimension by performing
     a binary operation on matching pairs of elements.
     
     - Parameters:
        - list: The list to be joined with. Each individual elements are used as rhs of bin operation.
        - operation: A binary operation.
     - Returns: A new list resulting from self ⊗ list.
     */
    public func join(with list: List, by bin: String) -> List {
        return List(elements.enumerated().map {
            Function(bin, [$0.element, list.elements[$0.offset]])
        })
    }

    /**
     Sort the list by using the provided comparator.
     
     - Parameter comparator: A binary function that compares two nodes.
     - Returns: A new list containing the original elements in sorted order
     */
    public func sorted(by comparator: PBinary) -> List {
        return List(elements.sorted(by: comparator))
    }
    
    /**
     Order the list according to their String
     representations.
     
     - Returns: A new list w/ elements sorted in natural order.
     */
    public func ordered() -> List {
        return sorted {(e1, e2) in
            return e1.stringified > e2.stringified
        }
    }
}
