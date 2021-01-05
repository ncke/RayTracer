//  Object.swift
//  Created by Nick on 03/01/2021.

import Foundation

protocol Object {
    func intersection(ray: Ray) -> Point?
    func normal(point: Point) -> Vector
}
