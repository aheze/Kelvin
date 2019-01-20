//
//  MutableListProtocol.swift
//  Kelvin
//
//  Created by Jiachen Ren on 1/20/19.
//  Copyright © 2019 Jiachen Ren. All rights reserved.
//

import Foundation

protocol MutableListProtocol: ListProtocol {
    var elements: [Node] { get set }
}

extension MutableListProtocol {
    
    /**
     Replace the designated nodes identical to the node provided with the replacement
     
     - Parameter predicament: The condition that needs to be met for a node to be replaced
     - Parameter replace:   A function that takes the old node as input (and perhaps
     ignores it) and returns a node as replacement.
     */
    public func replacing(by replace: Unary, where predicament: PUnary) -> Node {
        var copy = self
        copy.elements = copy.elements.map { element in
            return element.replacing(by: replace, where: predicament)
        }
        return predicament(copy) ? replace(copy) : copy
    }
    
    /**
     Simplify each element in the list.
     
     - Returns: A copy of the list with each element simplified.
     */
    public func simplify() -> Node {
        var copy = self
        copy.elements = elements.map {
            $0.simplify()
        }
        return copy
    }
    
    subscript(_ idx: Int) -> Node {
        get {
            return elements[idx]
        }
        set(newValue) {
            elements[idx] = newValue
        }
    }
}
