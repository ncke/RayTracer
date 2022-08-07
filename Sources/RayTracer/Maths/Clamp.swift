//
//  Clamp.swift
//  
//
//  Created by Nick on 06/08/2022.
//

import Foundation

extension Int {

    func clamp(_ min: Int, _ max: Int) -> Int {
        if self < min {
            return min
        } else if self > max {
            return max
        }

        return self
    }

}
