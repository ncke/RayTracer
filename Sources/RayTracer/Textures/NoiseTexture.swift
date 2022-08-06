//
//  NoiseTexture.swift
//  
//
//  Created by Nick on 05/08/2022.
//

import Foundation

// MARK: - Noise Texture

class NoiseTexture: Texture {

    let scale: Double

    init(scale: Double) {
        self.scale = scale
    }

}

// MARK: - Textured

extension NoiseTexture: Textured {

    func color(u: Double, v: Double, position: Vector3) -> Vector3 {
        let turbulence = Perlin.shared.turbulence(position: position, depth: 7)

        var res = Vector3(1.0, 1.0, 1.0)
        res *= 0.5
        res *= (1.0 + sin(scale * position.z + 10.0 * turbulence))

        return res
    }

}
