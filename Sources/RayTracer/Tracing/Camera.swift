//
//  Camera.swift
//  Created by Nick on 19/04/2022.
//

import Foundation

// MARK: - Camera

public struct Camera {
    let origin: Vector3
    private let dPixels: (Double, Double)
    var pixels: (Int, Int) { (Int(dPixels.0), Int(dPixels.1)) }
    var totalPixels: Int { Int(dPixels.0 * dPixels.1) }
    private let llCorner: Vector3
    private let horizontal: Vector3
    private let vertical: Vector3

    public init(
        lookFrom: (Double, Double, Double),
        lookAt: (Double, Double, Double),
        viewUp: (Double, Double, Double) = (0.0, 0.1, 0.0),
        verticalFieldOfView: Double,
        pixels: (Int, Int)
    ) {
        dPixels = (Double(pixels.0), Double(pixels.1))

        let aspect = dPixels.0 / dPixels.1
        let theta = verticalFieldOfView * Double.pi / 180.0
        let halfHeight = tan(theta / 2.0)
        let halfWidth = aspect * halfHeight

        origin = Vector3(lookFrom)

        let w = (origin - Vector3(lookAt)).normalised
        let u = (Vector3(viewUp) ⨯ w).normalised
        let v = w ⨯ u

        llCorner = origin - halfWidth * u - halfHeight * v - w;
        horizontal = 2.0 * halfWidth * u
        vertical = 2.0 * halfHeight * v
    }
}

// MARK: - Ray Generation

extension Camera {

    func ray(through pixel: (Int, Int), applyAntialias: Bool) -> Ray {
        var px = Double(pixel.0)
        var py = Double(pixel.1)

        if applyAntialias {
            px += Double.random(in: 0.0..<1.0)
            py += Double.random(in: 0.0..<1.0)
        }

        let u = px / dPixels.0
        let v = py / dPixels.1

        let ray = Ray(
            origin: origin,
            direction: llCorner + u * horizontal + v * vertical - origin
        )

        return ray
    }

}
