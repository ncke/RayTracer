//  ViewPlane.swift
//  Created by Nick on 02/01/2021.

import Foundation

// MARK: - View Plane

struct ViewPlane {
    let eye: Point
    let midpoint: Point
    let horizontal: Vector
    let vertical: Vector
    let screenWidth: Double
    let screenHeight: Double
}

// MARK: - Initialiser

extension ViewPlane {

    init(
        eye: Point,
        distance: Double,
        gaze: Vector,
        up: Vector,
        theta: Double,
        phi: Double,
        screenWidth: Double,
        screenHeight: Double
    ) {
        let x = gaze ✕ up
        let y = x ✕ gaze

        self.midpoint = eye + distance * gaze
        self.horizontal = distance * tan(theta) * x
        self.vertical = distance * tan(phi) * y
        self.eye = eye
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
    }

}

// MARK: - Compute Eye Rays

extension ViewPlane {

    func eyeRay(
        forScreenX x: Double,
        screenY y: Double
    ) -> Ray {
        let destination = point(forScreenX: x, screenY: y)

        return Ray(origin: eye, towards: destination)
    }

    private func point(
        forScreenX x: Double,
        screenY y: Double
    ) -> Point {
        let xPrime = 2.0 * (x / screenWidth) - 1.0
        let yPrime = 2.0 * (y / screenHeight) - 1.0

        return midpoint + xPrime * horizontal + yPrime * vertical
    }

}
