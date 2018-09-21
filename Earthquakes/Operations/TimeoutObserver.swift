/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file shows how to implement the OperationObserver protocol.
*/

import Foundation

/**
    `TimeoutObserver` is a way to make an `Operation` automatically time out and
    cancel after a specified time interval.
*/
struct TimeoutObserver: OperationObserver {
    // MARK: Properties

    static let timeoutKey = "Timeout"
    
    private let timeout: TimeInterval
    
    // MARK: Initialization
    
    init(timeout: TimeInterval) {
        self.timeout = timeout
    }
    
    // MARK: OperationObserver
    
    func operationDidStart(operation: AppleOperation) {
        // When the operation starts, queue up a block to cause it to time out.
      
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + (timeout)) {
            /*
                Cancel the operation if it hasn't finished and hasn't already
                been cancelled.
            */
          if !operation.isFinished && !operation.isCancelled {
                let error = NSError(code: .ExecutionFailed, userInfo: [
                  type(of: self).timeoutKey as NSObject: self.timeout as AnyObject
                ])

            operation.cancelWithError(error: error)
            }
        }
    }

    func operation(operation: AppleOperation, didProduceOperation newOperation: Operation) {
        // No op.
    }

    func operationDidFinish(operation: AppleOperation, errors: [Error]) {
        // No op.
    }
}
