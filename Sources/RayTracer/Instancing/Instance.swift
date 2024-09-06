import Foundation

// MARK: - Instance

public class Instance {
    let translation: Vector3
    let rotation: Vector3
    var intersectables: [Intersectable]

    public init(
        translation: (Double, Double, Double),
        rotation: (Double, Double, Double)
    ) {
        self.translation = Vector3(translation)
        self.rotation = Vector3(rotation)
        self.intersectables = []
    }

}

// MARK: - Instance Building

public extension Instance {

    func add(_ shape: Shape) {
        guard let intersectable = shape as? Intersectable else {
            fatalError()
        }

        intersectables.append(intersectable)
    }

    func add(_ instance: Instance) {
        intersectables.append(instance)
    }

    func spawn(
        translation: (Double, Double, Double),
        rotation: (Double, Double, Double)
    ) -> Instance {
        let spawned = Instance(translation: translation, rotation: rotation)
        spawned.intersectables = intersectables

        return spawned
    }

}

// MARK: - Intersectable

extension Instance: Intersectable {

    var flipNormal: Bool { false }

    func intersect(ray: Ray, tRange: Range<Double>) -> Intersection? {
        intersectables.nearestIntersection(ray: ray, tRange: tRange)
    }

}

// MARK: - Bounding Boxable

extension Instance: BoundingBoxable {

    func boundingBox() -> AxisAlignedBoundingBox {
        let boxables = intersectables.map { intersectable in
            intersectable as! BoundingBoxable
        }

        let surroundingBox = boxables.first!.boundingBox()
        return boxables.dropFirst().reduce(surroundingBox) { result, boxable in
            AxisAlignedBoundingBox.augmentedBox(result, boxable)
        }
    }

}
