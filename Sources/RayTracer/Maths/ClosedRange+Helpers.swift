//
//  ClosedRange+Helpers.swift
//  
//
//  Created by Nick on 27/08/2022.
//

import Foundation

// MARK: - Closed Range Helpers

extension ClosedRange where Bound == Double {

    static let epsilon = 1E-5

    func extended(
        by epsilon: Double = ClosedRange.epsilon
    ) -> ClosedRange<Double> {
        (self.lowerBound - epsilon) ... (self.upperBound + epsilon)
    }

    var size: Double {
        self.upperBound - self.lowerBound
    }

}
