import Foundation

// MARK: - Constant Texture

public class ConstantTexture: Texture {

    let textureColor: Vector3

    public init(r: Double, g: Double, b: Double) {
        textureColor = Vector3(r, g, b)
    }

    public init(uniform: Double) {
        textureColor = Vector3(uniform: uniform)
    }

}

// MARK: - Textured

extension ConstantTexture: Textured {

    func color(u: Double, v: Double, position: Vector3) -> Vector3 {
        return textureColor
    }

}
