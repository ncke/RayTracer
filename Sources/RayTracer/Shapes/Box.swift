//
//  Box.swift
//  
//
//  Created by Nick on 27/08/2022.
//

import Foundation

// MARK: - Box

public class Box: Shape {
    let pMin: Vector3
    let pMax: Vector3
    let sides: [Intersectable]
    public var material: Material
    public var emitter: Emitter?

    init(p0: (Double, Double, Double), p1: (Double, Double, Double), material: Material, emitter: Emitter? = nil) {
        self.pMin = Vector3(p0)
        self.pMax = Vector3(p1)
        self.material = material
        self.emitter = emitter

        let side1 = XYRectangle(x0: pMin.x, y0: pMin.y, x1: pMax.x, y1: pMax.y, z: pMax.z, material: material)
        let side2 = XYRectangle(x0: pMin.x, y0: pMin.y, x1: pMax.x, y1: pMax.y, z: pMin.z, material: material)
        let side3 = XZRectangle(x0: pMin.x, z0: pMin.z, x1: pMax.x, z1: pMax.z, y: pMax.y, material: material)
        let side4 = XZRectangle(x0: pMin.x, z0: pMin.z, x1: pMax.x, z1: pMax.z, y: pMin.y, material: material)
        let side5 = YZRectangle(y0: pMin.y, z0: pMin.z, y1: pMax.y, z1: pMax.z, x: pMax.x, material: material)
        let side6 = YZRectangle(y0: pMin.y, z0: pMin.z, y1: pMax.y, z1: pMax.z, x: pMin.x, material: material)

        self.sides = [ side1, side2, side3, side4, side5, side6 ]
    }

}

// MARK: - Intersectable

extension Box: Intersectable {

    var flipNormal: Bool { false }

    func intersect(ray: Ray, tRange: Range<Double>) -> Intersection? {
        sides.nearestIntersection(ray: ray, tRange: tRange)
    }

}

// MARK: - Bounding Boxable

extension Box: BoundingBoxable {

    func boundingBox() -> AxisAlignedBoundingBox {
        AxisAlignedBoundingBox(pMin, pMax)
    }

}
