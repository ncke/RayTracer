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

    func color(u: Double, v: Double, hitPoint: Vector3) -> Vector3 {
        let turb = Perlin.shared.turbulence(position: hitPoint, depth: 7)

        let res = Vector3(1.0, 1.0, 1.0)
            * 0.5
            * (1.0 + sin(
                scale * hitPoint.z + 10.0 * Perlin.shared.turbulence(position: hitPoint, depth: 7))
            )

        return res
    }

}
