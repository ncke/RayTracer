//  ViewPlane.swift
//  Created by Nick on 02/01/2021.

import Foundation

// MARK: - View Plane

struct ViewPlane {
    let eye: Point
    let midpoint: Point
    let horizontal: Vector
    let vertical: Vector
    let imageWidth: Double
    let imageHeight: Double
}

// MARK: - Initialiser

extension ViewPlane {

    init(
        eye: Point,
        distance: Double,
        gaze: Vector,
        up: Vector,
        theta: Radians,
        phi: Radians,
        imageWidth: Double,
        imageHeight: Double
    ) {
        let x = gaze ✕ up
        let y = x ✕ gaze

        self.midpoint = eye + distance * gaze
        self.horizontal = distance * tan(theta) * x
        self.vertical = distance * tan(phi) * y
        self.eye = eye
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
    }

}

// MARK: - Compute Eye Rays

extension ViewPlane {

    func eyeRay(
        forScreenX x: Int,
        screenY y: Int
    ) -> Ray {
        let destination = point(forScreenX: x, screenY: y)

        return Ray(origin: eye, towards: destination)
    }

    private func point(
        forScreenX x: Int,
        screenY y: Int
    ) -> Point {
        let xPrime = 2.0 * (Double(x) / imageWidth) - 1.0
        let yPrime = 2.0 * (Double(y) / imageHeight) - 1.0

        return midpoint + xPrime * horizontal + yPrime * vertical
    }

}
