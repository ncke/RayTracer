import Foundation

// MARK: - XYRectangle

public struct XYRectangle: Shape {
    let xRange: ClosedRange<Double>
    let yRange: ClosedRange<Double>
    let zRectangle: Double
    let flipNormal: Bool
    public let material: Material
    public let emitter: Emitter?

    public init(
        x0: Double,
        y0: Double,
        x1: Double,
        y1: Double,
        z: Double,
        material: Material,
        emitter: Emitter? = nil,
        flipNormal: Bool = false
    ) {
        xRange = x0 ... x1
        yRange = y0 ... y1
        zRectangle = z
        self.material = material
        self.emitter = emitter
        self.flipNormal = flipNormal
    }

}

// MARK: - Intersectable

extension XYRectangle: Intersectable {

    func intersect(ray: Ray, tRange: Range<Double>) -> Intersection? {
        let t = (zRectangle - ray.origin.z) / ray.direction.z
        guard tRange.contains(t) else {
            return nil
        }

        let x = ray.origin.x + t * ray.direction.x
        let y = ray.origin.y + t * ray.direction.y
        guard xRange.contains(x), yRange.contains(y) else {
            return nil
        }

        let u = (x - xRange.lowerBound) / xRange.size
        let v = (y - yRange.lowerBound) / yRange.size

        return Intersection(
            shape: self,
            hitDistance: t,
            hitPoint: t * ray,
            uvCoordinate: (u, v),
            outwardNormal: Vector3(0.0, 0.0, 1.0),
            flipNormal: flipNormal,
            incidentRay: ray
        )
    }

}

// MARK: - Bounding Boxable

extension XYRectangle: BoundingBoxable {

    func boundingBox() -> AxisAlignedBoundingBox {
        let xBoxed = xRange.extended()
        let yBoxed = yRange.extended()

        let a = Vector3(
            xBoxed.lowerBound,
            yBoxed.lowerBound,
            zRectangle - ClosedRange.epsilon)

        let b = Vector3(
            xBoxed.upperBound,
            yBoxed.upperBound,
            zRectangle + ClosedRange.epsilon)

        return AxisAlignedBoundingBox(a, b)
    }

}
