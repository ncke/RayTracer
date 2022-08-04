//
//  Texture.swift
//  
//
//  Created by Nick on 04/08/2022.
//

import Foundation

public class Texture {}

protocol Textured {

    func color(u: Double, v: Double) -> Vector3

}

public class ConstantTexture: Texture {

    let textureColor: Vector3

    init(r: Double, g: Double, b: Double) {
        textureColor = Vector3(r, g, b)
    }

    init(uniform: Double) {
        textureColor = Vector3(uniform: uniform)
    }

}

extension ConstantTexture: Textured {

    func color(u: Double, v: Double) -> Vector3 {
        return textureColor
    }
    
}
