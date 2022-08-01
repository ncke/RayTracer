//
//  ImageArray.swift
//  
//
//  Created by Nick on 31/07/2022.
//

import Foundation

public class ImageArray {
    let size: (Int, Int)
    var pixels: [[RGBColor]]

    private var xSize: Int { size.0 }
    private var ySize: Int { size.1 }

    init(size: (Int, Int)) {
        self.size = size
        self.pixels = [[RGBColor]](
            repeating: [RGBColor](repeating: RGBColor.black, count: size.0),
            count: size.1
        )
    }

    func pixel(at coordinate: (Int, Int)) -> RGBColor {
        pixels[coordinate.1][coordinate.0]
    }

    func setPixel(at coordinate: (Int, Int), rgb: RGBColor) {
        pixels[coordinate.1][coordinate.0] = rgb
    }

}

public extension ImageArray {

    var asP3String: String {
        var p3str: String = "P3\n\(xSize) \(ySize)\n255\n"

        for coordinate in allPixels {
            let rgb = pixel(at: coordinate)
            p3str += "\(rgb.red) \(rgb.green) \(rgb.blue)\n"
        }

        return p3str
    }

}

// MARK: - Pixels Sequence

extension ImageArray {

    struct PixelSequence: Sequence, IteratorProtocol {
        private let size: (Int, Int)
        private var current: (Int, Int)

        init(size: (Int, Int)) {
            self.size = size
            self.current = (-1, size.1 - 1)
        }

        mutating func next() -> (Int, Int)? {
            var (x, y) = current
            x += 1

            if x >= size.0 {
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
        PixelSequence(size: size)
    }

}
