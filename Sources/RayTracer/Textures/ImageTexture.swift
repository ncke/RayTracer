import Foundation

// MARK: - Image Texture

public class ImageTexture: Texture {

    let imageMap: ImageMap

    public init(imageMap: ImageMap) {
        self.imageMap = imageMap
    }

}

// MARK: - Textured

extension ImageTexture: Textured {

    func color(u: Double, v: Double, position: Vector3) -> Vector3 {
        let i = Int(u * Double(imageMap.xSize - 1)).clamp(0, imageMap.xSize - 1)
        let j = Int(v * Double(imageMap.ySize - 1)).clamp(0, imageMap.ySize - 1)
        let rgb = imageMap.rgbColor(at: (i, j))

        return Vector3(rgb) / 255.0
    }

}
