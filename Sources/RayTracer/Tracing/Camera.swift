//
//  Camera.swift
//  Created by Nick on 19/04/2022.
//

import Foundation

// MARK: - Camera

public struct Camera {
    let origin: Vector3
    let size: (Double, Double)
    let pixels: (Int, Int)

    private let dPixels: (Double, Double)
    private let llCorner: Vector3
    private let horizontal: Vector3
    private let vertical: Vector3

    public init(
        origin: (Double, Double, Double),
        size: (Double, Double),
        pixels: (Int, Int)
    ) {
        self.origin = Vector3(origin)
        self.size = size
        self.pixels = pixels
        self.dPixels = (Double(pixels.0), Double(pixels.1))
        self.llCorner = Vector3(-0.5 * size.0, -0.5 * size.1, -1.0)
        self.horizontal = Vector3(size.0, 0.0, 0.0)
        self.vertical = Vector3(0.0, size.1, 0.0)
    }
}

// MARK: - Pixels Sequence

extension Camera {

    struct PixelSequence: Sequence, IteratorProtocol {
        private let pixels: (Int, Int)
        private var current: (Int, Int)

        init(pixels: (Int, Int)) {
            self.pixels = pixels
            self.current = (-1, pixels.1 - 1)
        }

        mutating func next() -> (Int, Int)? {
            var (x, y) = current
            x += 1

            if x >= pixels.0 {
                x = 0

                y -= 1
                if y < 0 {
                    return nil
                }
            }

            current = (x, y)
            return current
        }
    }

    var allPixels: PixelSequence {
        PixelSequence(pixels: pixels)
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
            direction: llCorner + u * horizontal + v * vertical
        )

        return ray
    }

}
