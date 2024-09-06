import Foundation

// MARK: - Checker Texture

public class CheckerTexture: Texture {
    let oddTextured: Textured
    let evenTextured: Textured
    let scale: Double

    public init(_ oddTexture: Texture, _ evenTexture: Texture, scale: Double) {
        guard
            let odd = oddTexture as? Textured,
            let even = evenTexture as? Textured
        else {
            fatalError()
        }

        self.oddTextured = odd
        self.evenTextured = even
        self.scale = scale
    }

}

// MARK: - Textured

extension CheckerTexture: Textured {

    func color(u: Double, v: Double, position: Vector3) -> Vector3 {
        let sines = sin(scale * position.x)
            * sin(scale * position.y)
            * sin(scale * position.z)

        return sines < Double.zero
            ? oddTextured.color(u: u, v: v, position: position)
            : evenTextured.color(u: u, v: v, position: position)
    }

}
