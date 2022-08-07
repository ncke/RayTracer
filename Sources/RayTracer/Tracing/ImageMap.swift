//
//  ImageMap.swift
//  
//
//  Created by Nick on 31/07/2022.
//

import Foundation

// MARK: - Image Map

public class ImageMap {
    let size: (Int, Int)
    var pixels: [[RGBColor]]

    var xSize: Int { size.0 }
    var ySize: Int { size.1 }

    init(size: (Int, Int)) {
        self.size = size
        self.pixels = [[RGBColor]](
            repeating: [RGBColor](repeating: RGBColor.black, count: size.0),
            count: size.1
        )
    }

}

// MARK: - Get and Set

extension ImageMap {

    func pixel(at coordinate: (Int, Int)) -> RGBColor {
        pixels[coordinate.1][coordinate.0]
    }

    func rgbColor(at coordinate: (Int, Int)) -> (Int, Int, Int) {
        let rgb = pixel(at: coordinate)
        return (rgb.red, rgb.green, rgb.blue)
    }

    func setPixel(at coordinate: (Int, Int), rgb: RGBColor) {
        pixels[coordinate.1][coordinate.0] = rgb
    }

}

// MARK: - P3 Format

public extension ImageMap {

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

extension ImageMap {

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

// MARK: - NSImage Helper

#if canImport(AppKit)

import AppKit

extension ImageMap {

    static func fromNSImage(_ image: NSImage) -> ImageMap? {
        guard let data = image.tiffRepresentation else {
            return nil
        }

        let reps = NSBitmapImageRep.imageReps(with: data)

        guard reps.count > 0, let bitmap = reps[0] as? NSBitmapImageRep else {
            return nil
        }

        let size = (Int(bitmap.size.width), Int(bitmap.size.height))

        let imageMap = ImageMap(size: size)
        for x in 0..<imageMap.xSize {
            for y in 0..<imageMap.ySize {
                guard let color = bitmap.colorAt(x: x, y: y) else {
                    fatalError()
                }

                let rgb = RGBColor(
                    color.redComponent,
                    color.greenComponent,
                    color.blueComponent
                )

                let coord = (x, size.1 - 1 - y)
                imageMap.setPixel(at: coord, rgb: rgb)
            }
        }

        return imageMap
    }

}

#endif
