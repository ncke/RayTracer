import CoreGraphics

struct RayTracer {
    private let viewPlane: ViewPlane
    private let scene: Scene
    private let imageWidth: Int
    private let imageHeight: Int
}

extension RayTracer {

    init() {

        self.viewPlane = ViewPlane(
            eye: Point.zero,
            distance: 10.0,
            gaze: Vector(0.0, 0.0, 1.0),
            up: Vector(0.0, 1.0, 0.0),
            theta: 45.0,
            phi: 45.0,
            imageWidth: 240.0,
            imageHeight: 240.0
        )

        let sphere1 = Sphere(
            center: Point(0.0, 0.0, 30.0),
            radius: 12.0
        )

        let sphere2 = Sphere(
            center: Point(-5.0, -5.0, 12.0),
            radius: 2.0
        )

        let light = LightSource(
            center: Point(-10.0, -10.0, -50.0),
            radius: 10.0,
            intensity: 1.0
        )

        self.scene = Scene(objects: [sphere1, sphere2], lights: [light])

        self.imageWidth = 240
        self.imageHeight = 240
    }

    func trace() -> CGImage? {
        let traceImage = TraceImage(dataSource: self)
        return traceImage.trace()
    }

}

// MARK: - Trace Image Data Source

extension RayTracer: TraceImageDataSource {

    func imageSize() -> ImageSize { (imageWidth, imageHeight) }

    func rgb(_ x: Int, _ y: Int) -> ImageRGB {
        let eyeRay = viewPlane.eyeRay(forScreenX: x, screenY: y)

        guard let hit = scene.objectHit(by: eyeRay) else {
            return (0.8, 0.8, 0.8)
        }

        guard let lights = scene.lightsVisible(from: hit.point) else {
            return (0.0, 0.0, 0.0)
        }

        for light in lights {
            let n = hit.object.normal(point: hit.point).normalized
            let l = Vector(from: hit.point, towards: light.center).normalized
            let e = Vector(from: hit.point, towards: eyeRay.origin).normalized

            let d = n • l
            let r = 2 * n * d - l
            let k = 8.0
            let sr = light.intensity * pow(e • r, k)
            let c = (sr + 1.0) / 2.0

            print(sr, c)

            return (c, 0.0, 0.0)
        }

        return (1.0, 0.0, 0.0)
    }

}
