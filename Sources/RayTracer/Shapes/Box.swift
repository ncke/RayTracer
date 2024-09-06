import Foundation

// MARK: - Box

public class Box: Shape {
    let pMin: Vector3
    let pMax: Vector3
    let sides: [Intersectable]
    public var material: Material
    public var emitter: Emitter?

    public init(
        oppositeCorners p0: (Double, Double, Double),
        _ p1: (Double, Double, Double),
        material: Material,
        emitter: Emitter? = nil
    ) {
        self.material = material
        self.emitter = emitter

        let (bottom, top) = Box.orientateCorners(Vector3(p0), Vector3(p1))
        self.pMin = bottom
        self.pMax = top
        self.sides = Box.makeSides(pMin: pMin, pMax: pMax, material: material)
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

// MARK: - Corner Orientation

private extension Box {

    static func orientateCorners(
        _ v0: Vector3,
        _ v1: Vector3
    ) -> (Vector3, Vector3) {
        let bottom = Vector3(
            min(v0.x, v1.x),
            min(v0.y, v1.y),
            min(v0.z, v1.z))

        let top = Vector3(
            max(v0.x, v1.x),
            max(v0.y, v1.y),
            max(v0.z, v1.z))

        return (bottom, top)
    }

}

// MARK: - Sides

private extension Box {

    static func makeSides(
        pMin: Vector3,
        pMax: Vector3,
        material: Material
    ) -> [Intersectable] {
        let side1 = XYRectangle(
            x0: pMin.x, y0: pMin.y,
            x1: pMax.x, y1: pMax.y,
            z: pMax.z,
            material: material)

        let side2 = XYRectangle(
            x0: pMin.x, y0: pMin.y,
            x1: pMax.x, y1: pMax.y,
            z: pMin.z,
            material: material)

        let side3 = XZRectangle(
            x0: pMin.x, z0: pMin.z,
            x1: pMax.x, z1: pMax.z,
            y: pMax.y,
            material: material)

        let side4 = XZRectangle(
            x0: pMin.x, z0: pMin.z,
            x1: pMax.x, z1: pMax.z,
            y: pMin.y,
            material: material)

        let side5 = YZRectangle(
            y0: pMin.y, z0: pMin.z,
            y1: pMax.y, z1: pMax.z,
            x: pMax.x,
            material: material)

        let side6 = YZRectangle(
            y0: pMin.y, z0: pMin.z,
            y1: pMax.y, z1: pMax.z,
            x: pMin.x,
            material: material)

        return [ side1, side2, side3, side4, side5, side6 ]
    }

}
