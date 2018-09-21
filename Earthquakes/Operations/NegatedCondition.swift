/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
The file shows how to make an OperationCondition that composes another OperationCondition.
*/

import Foundation

/**
    A simple condition that negates the evaluation of another condition.
    This is useful (for example) if you want to only execute an operation if the
    network is NOT reachable.
*/
struct NegatedCondition<T: OperationCondition>: OperationCondition {
    static var name: String {
        return "Not<\(T.name)>"
    }
    
    static var negatedConditionKey: String {
        return "NegatedCondition"
    }
    
    static var isMutuallyExclusive: Bool {
        return T.isMutuallyExclusive
    }
    
    let condition: T

    init(condition: T) {
        self.condition = condition
    }
    
    func dependencyForOperation(operation: AppleOperation) -> Operation? {
      return condition.dependencyForOperation(operation: operation)
    }
    
  func evaluateForOperation(operation: AppleOperation, completion: @escaping (OperationConditionResult) -> Void) {
    condition.evaluateForOperation(operation: operation) { result in
            if result == .Satisfied {
                // If the composed condition succeeded, then this one failed.
                let error = NSError(code: .ConditionFailed, userInfo: [
                  OperationConditionKey as NSObject: type(of: self).name as AnyObject,
                  type(of: self).negatedConditionKey as NSObject: type(of: self.condition).name as AnyObject
                    ])
                
                completion(.Failed(error))
            }
            else {
                // If the composed condition failed, then this one succeeded.
                completion(.Satisfied)
            }
        }
    }
}
