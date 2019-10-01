//
//  StackTrace+Supplier.swift
//  Kelvin
//
//  Created by Jiachen Ren on 9/30/19.
//  Copyright © 2019 Jiachen Ren. All rights reserved.
//

import Foundation

extension StackTrace: Supplier {

    static let exports: [Operation] = [
        .init(.printStackTrace, []) { _ in
            Program.io?.println(KString(StackTrace.shared.genStackTrace()))
            return KVoid()
        },
        .init(.clearStackTrace, []) { _ in
            StackTrace.shared.clear()
            Program.io?.println(KString("stack trace history has been cleared."))
            return KVoid()
        },
        .unary(.setStackTraceEnabled, Bool.self) {
            StackTrace.shared.isEnabled = $0
            let enabled = $0 ? "enabled" : "disabled"
            Program.io?.println(KString("stack trace \(enabled)"))
            return KVoid()
        },
        .unary(.setStackTraceUntracked, List.self) {
            let untracked = try Assert.specialize(list: $0, as: KString.self).map {$0.string}.filter {
                let isDefined = Operation.registered.keys.contains($0)
                if (!isDefined) {
                    Program.io?.println(KString("warning - \($0) is undefined"))
                }
                return isDefined
            }
            Program.io?.println(KString("untracked \(untracked)"))
            StackTrace.shared.untracked = untracked
            return KVoid()
        }
    ]
}
