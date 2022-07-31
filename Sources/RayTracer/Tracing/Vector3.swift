//
//  Vector3.swift
//  Created by Nick on 19/04/2022.
//

import Foundation

// MARK: - Vector3

struct Vector3 {
    var x: Double
    var y: Double
    var z: Double

    init(_ x: Double, _ y: Double, _ z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }

    init(_ tuple: (Double, Double, Double)) {
        self.init(tuple.0, tuple.1, tuple.2)
    }

    init(uniform: Double) {
        self.init(uniform, uniform, uniform)
    }
}

// MARK: - Zero and Unit

extension Vector3 {

    static let zero = Vector3(0.0, 0.0, 0.0)

    static let unit = Vector3(1.0, 1.0, 1.0)

}

// MARK: - Negation

extension Vector3 {

    static prefix func - (vec: Vector3) -> Vector3 {
        Vector3(-vec.x, -vec.y, -vec.z)
    }

}

// MARK: - Basic Maths

extension Vector3 {

    static func + (lhs: Vector3, rhs: Vector3) -> Vector3 {
        Vector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }

    static func += (lhs: inout Vector3, rhs: Vector3) {
        lhs.x = lhs.x + rhs.x
        lhs.y = lhs.y + rhs.y
        lhs.z = lhs.z + rhs.z
    }

    static func - (lhs: Vector3, rhs: Vector3) -> Vector3 {
        Vector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }

    static func -= (lhs: inout Vector3, rhs: Vector3) {
        lhs.x = lhs.x - rhs.x
        lhs.y = lhs.y - rhs.y
        lhs.z = lhs.z - rhs.z
    }

    static func * (lhs: Vector3, rhs: Vector3) -> Vector3 {
        Vector3(lhs.x * rhs.x, lhs.y * rhs.y, lhs.z * rhs.z)
    }

    static func *= (lhs: inout Vector3, rhs: Vector3) {
        lhs.x = lhs.x * rhs.x
        lhs.y = lhs.y * rhs.y
        lhs.z = lhs.z * rhs.z
    }

    static func / (lhs: Vector3, rhs: Vector3) -> Vector3 {
        Vector3(lhs.x / rhs.x, lhs.y / rhs.y, lhs.z / rhs.z)
    }

    static func /= (lhs: inout Vector3, rhs: Vector3) {
        lhs.x = lhs.x / rhs.x
        lhs.y = lhs.y / rhs.y
        lhs.z = lhs.z / rhs.z
    }

}

// MARK: - Scalar Multiply and Divide

extension Vector3 {

    static func * (lhs: Double, rhs: Vector3) -> Vector3 {
        Vector3(lhs * rhs.x, lhs * rhs.y, lhs * rhs.z)
    }

    static func * (lhs: Vector3, rhs: Double) -> Vector3 {
        Vector3(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs)
    }

    static func / (lhs: Vector3, rhs: Double) -> Vector3 {
        Vector3(lhs.x / rhs, lhs.y / rhs, lhs.z / rhs)
    }

}

// MARK: - Dot and Cross Products

infix operator ⋅ : MultiplicationPrecedence
infix operator ⨯ : MultiplicationPrecedence

extension Vector3 {

    static func ⋅ (lhs: Vector3, rhs: Vector3) -> Double {
        lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z
    }

    static func ⨯ (lhs: Vector3, rhs: Vector3) -> Vector3 {
        Vector3(
            lhs.y * rhs.z - lhs.z * rhs.y,
            lhs.z * rhs.x - lhs.x * rhs.z,
            lhs.x * rhs.y - lhs.y * rhs.x
        )
    }

}

// MARK: - Length and Normalisation

extension Vector3 {

    var length: Double {
        sqrt(squareLength)
    }

    var squareLength: Double {
        self ⋅ self
    }

    var normalised: Vector3 {
        self / length
    }

}

// MARK: - Averaging

extension Collection where Element == Vector3 {

    var average: Vector3? {
        guard self.count > 0 else {
            return nil
        }

        let count = Double(self.count)
        let total = self.reduce(Vector3.zero) { accumulator, element in
            accumulator + element
        }
        
        return Vector3(
            total.x / count,
            total.y / count,
            total.z / count
        )
    }

}

// MARK: - Reflection

extension Vector3 {

    func reflected(normal: Vector3) -> Vector3 {
        self - 2.0 * (self ⋅ normal) * normal
    }

}

// MARK: - Refraction

extension Vector3 {

    func refracted(
        normal: Vector3,
        refractiveIndex: RefractiveIndex
    ) -> Vector3 {

        func direction(
            normal: Vector3,
            refractiveIndex: RefractiveIndex
        ) -> (Vector3, Double, Double) {
            let dotted = self ⋅ normal

            if dotted > Double.zero {
                let cosine = (refractiveIndex.index * dotted) / length
                return (-normal, refractiveIndex.index, cosine)

            } else {
                let cosine = -dotted / length
                return (normal, refractiveIndex.invertedIndex, cosine)
            }
        }

        let (outwardNormal, outwardIndex, cosine) = direction(
            normal: normal,
            refractiveIndex: refractiveIndex
        )

        func shouldSchlickReflect() -> Bool {
            let r0 = (1.0 - outwardIndex) / (1.0 + outwardIndex)
            let r0_squared = r0 * r0
            let schlick = r0_squared + (1.0 - r0_squared) * pow(1.0 - cosine, 5)

            return Double.random(in: 0..<1.0) > schlick
        }

        let dt = self.normalised ⋅ outwardNormal
        let discriminant = 1.0 - outwardIndex * outwardIndex * (1.0 - dt * dt)

        let shouldRefract = discriminant > Double.zero
            && !shouldSchlickReflect()

        guard shouldRefract else {
            return reflected(normal: normal)
        }

        let refraction =
            outwardIndex * (self - outwardNormal * dt)
                - outwardNormal * sqrt(discriminant)

        return refraction
    }

}
