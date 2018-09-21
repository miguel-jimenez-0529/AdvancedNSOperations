/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file shows how to implement the OperationObserver protocol.
*/

import Foundation

/**
    The `BlockObserver` is a way to attach arbitrary blocks to significant events
    in an `Operation`'s lifecycle.
*/
struct BlockObserver: OperationObserver {
    // MARK: Properties
    
  private let startHandler: ((AppleOperation) -> Void)?
    private let produceHandler: ((AppleOperation, Operation) -> Void)?
    private let finishHandler: ((AppleOperation, [Error]) -> Void)?
    
  init(startHandler: ((AppleOperation) -> Void)? = nil, produceHandler: ((AppleOperation, Operation) -> Void)? = nil, finishHandler: ((AppleOperation, [Error]) -> Void)? = nil) {
        self.startHandler = startHandler
        self.produceHandler = produceHandler
        self.finishHandler = finishHandler
    }
    
    // MARK: OperationObserver
    
    func operationDidStart(operation: AppleOperation) {
        startHandler?(operation)
    }
    
    func operation(operation: AppleOperation, didProduceOperation newOperation: Operation) {
        produceHandler?(operation, newOperation)
    }
    
    func operationDidFinish(operation: AppleOperation, errors: [Error]) {
        finishHandler?(operation, errors)
    }
}
