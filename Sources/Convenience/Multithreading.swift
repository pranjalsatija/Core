//
//  Convenience.swift
//  Core
//
//  Created by Pranjal Satija on 1/12/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import Foundation

/// Executes the provided block asynchronously on an arbitrary operation queue.
/// - parameter completionHandler: A completion handler to call when the block is done.
/// The handler has an optional `Error` parameter.
func background(_ block: @escaping () throws -> Void, completionHandler: ((Swift.Error?) -> Void)? = nil) {
    OperationQueue().addOperation {
        do {
            try block()
            completionHandler?(nil)
        } catch {
            completionHandler?(error)
        }
    }
}

/// Executes the provided block asynchronously on an arbitrary operation queue.
func background(_ block: @escaping () -> Void) {
    OperationQueue().addOperation(block)
}

/// Executes the provided block asynchronously on the main operation queue.
func main(_ block: @escaping () -> Void) {
    OperationQueue.main.addOperation(block)
}
