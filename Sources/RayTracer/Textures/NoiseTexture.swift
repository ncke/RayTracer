//
//  NoiseTexture.swift
//  
//
//  Created by Nick on 05/08/2022.
//

import Foundation

// MARK: - Noise Texture

class NoiseTexture: Texture {

    let textureColor: Vector3
    let scale: Double

    init(r: Double, g: Double, b: Double, scale: Double) {
        self.textureColor = Vector3(r, g, b)
        self.scale = scale
    }

}

// MARK: - Textured

extension NoiseTexture: Textured {

    func color(u: Double, v: Double, position: Vector3) -> Vector3 {
        let turbulence = Perlin.shared.turbulence(position: position, depth: 7)

        var res = 0.5 * textureColor
        res *= (1.0 + sin(scale * position.z + 10.0 * turbulence))

        return res
    }

}
