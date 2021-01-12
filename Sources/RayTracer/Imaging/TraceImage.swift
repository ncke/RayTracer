//  TraceImage.swift
//  Created by Nick on 03/01/2021.

import Foundation

typealias ImageSize = (Int, Int)
typealias ImageRGB = (Double, Double, Double)

protocol TraceImageDataSource {
    func imageSize() -> ImageSize
    func rgb(_ x: Int, _ y: Int) -> ImageRGB
}

struct TraceImage {
    let dataSource: TraceImageDataSource
}

extension TraceImage {

    private typealias Pixel = (UInt8, UInt8, UInt8, UInt8)

    func trace() -> CGImage? {
        let (width, height) = dataSource.imageSize()

        guard
            let cgContext = CGContext(
                data: nil,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: 4 * width,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
            ),
            let buffer = cgContext.data?.bindMemory(
                to: Pixel.self,
                capacity: width * height
            )
        else {
            return nil
        }

        var index = 0
        for x in 0..<width {
            for y in 0..<height {

                let (r, g, b) = dataSource.rgb(x, y)
                let pixel: Pixel = (
                    UInt8(r * 255.0),
                    UInt8(g * 255.0),
                    UInt8(b * 255.0),
                    UInt8(255)
                )

                buffer[index] = pixel
                index += 1
            }
        }

        return cgContext.makeImage()
    }

}
