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

// MARK: - Subscript

extension Vector3 {

    subscript(_ i: Int) -> Double {
        switch i {
        case 0: return x
        case 1: return y
        case 2: return z
        default: fatalError()
        }
    }

}

// MARK: - Zero and Unit

extension Vector3 {

    static let zero = Vector3(0.0, 0.0, 0.0)

    static let unit = Vector3(1.0, 1.0, 1.0)

    private static let epsilon = 1.0e-8

    var isNearZero: Bool {
        abs(x) < Vector3.epsilon
            && abs(y) < Vector3.epsilon
            && abs(z) < Vector3.epsilon
    }

    static var randomUnitVector: Vector3 {
        Vector3(
            -1.0 + Double.random(in: 0..<2.0),
            -1.0 + Double.random(in: 0..<2.0),
            -1.0 + Double.random(in: 0..<2.0)
        ).normalised
    }

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

    static func *= (lhs: inout Vector3, rhs: Double) {
        lhs = lhs * rhs
    }

    static func / (lhs: Vector3, rhs: Vector3) -> Vector3 {
        Vector3(lhs.x / rhs.x, lhs.y / rhs.y, lhs.z / rhs.z)
    }

    static func /= (lhs: inout Vector3, rhs: Vector3) {
        lhs.x = lhs.x / rhs.x
        lhs.y = lhs.y / rhs.y
        lhs.z = lhs.z / rhs.z
    }

    static func /= (lhs: inout Vector3, rhs: Double) {
        lhs = lhs / rhs
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
        refractiveIndex: Double
    ) -> Vector3 {

        let unitDirection = self.normalised
        let cosTheta = min((-unitDirection) ⋅ normal, 1.0)
        let sinTheta = sqrt(1.0 - cosTheta * cosTheta)

        func shouldSchlickReflect() -> Bool {
            let r0 = (1.0 - refractiveIndex) / (1.0 + refractiveIndex)
            let r0_sqr = r0 * r0
            let schlick = r0_sqr + (1.0 - r0_sqr) * pow(1.0 - cosTheta, 5)

            return Double.random(in: 0..<1.0) < schlick
        }

        guard refractiveIndex * sinTheta <= 1.0, !shouldSchlickReflect() else {
            return reflected(normal: normal)
        }

        let perp = refractiveIndex * (unitDirection + cosTheta * normal)
        let para = -sqrt(abs(1.0 - perp.squareLength)) * normal

        return perp + para
    }

}

// MARK: - Hermite Cubic

extension Vector3 {

    var hermiteCubic: Vector3 {
        Vector3(
            x * x * (3.0 - 2.0 * x),
            y * y * (3.0 - 2.0 * y),
            z * z * (3.0 - 2.0 * z)
        )
    }

}
