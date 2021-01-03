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
            theta: 20.0,
            phi: 20.0,
            imageWidth: 240.0,
            imageHeight: 240.0
        )

        let sphere1 = Sphere(
            center: Point(0.0, 0.0, 20.0),
            radius: 12.0
        )

        let sphere2 = Sphere(
            center: Point(20.0, 20.0, 40.0),
            radius: 10.0
        )

        self.scene = Scene(objects: [ sphere1, sphere2 ])

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

    func rbg(_ x: Int, _ y: Int) -> ImageRGB {
        let eyeRay = viewPlane.eyeRay(forScreenX: x, screenY: y)
        for object in scene.objects {
            if object.intersection(ray: eyeRay) != nil {
                return (1.0, 0.0, 0.0)
            }
        }

        return (0.8, 0.8, 0.8)
    }

}
