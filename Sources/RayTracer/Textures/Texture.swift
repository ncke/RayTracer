//
//  Texture.swift
//  
//
//  Created by Nick on 04/08/2022.
//

import Foundation

public class Texture {}

protocol Textured {

    func color(u: Double, v: Double, position: Vector3) -> Vector3

}
