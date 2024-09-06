import Foundation

// MARK: - Intersectable

protocol Intersectable {

    var flipNormal: Bool { get }

    func intersect(ray: Ray, tRange: Range<Double>) -> Intersection?

}

// MARK: - Intersection

struct Intersection {
    let shape: Shape
    let hitDistance: Double
    let hitPoint: Vector3
    let uvCoordinate: (Double, Double)
    let normal: Vector3
    let isFrontFace: Bool
}

extension Intersection {

    init(
        shape: Shape,
        hitDistance: Double,
        hitPoint: Vector3,
        uvCoordinate: (Double, Double),
        outwardNormal: Vector3,
        flipNormal: Bool,
        incidentRay: Ray
    ) {
        self.shape = shape
        self.hitDistance = hitDistance
        self.hitPoint = hitPoint
        self.uvCoordinate = uvCoordinate

        isFrontFace = (incidentRay.direction ⋅ outwardNormal) < Double.zero

        normal = isFrontFace ? outwardNormal : -outwardNormal
    }

}
