import Foundation

// MARK: - Ray Tracer Progress Delegate

public protocol RayTracerProgressDelegate {

    func rayTracerWorker(
        _ worker: RayTracerWorker,
        pixelsRemaining: Int,
        pixelsTotal: Int,
        fractionCompleted: Double
    )

}

// MARK: - Worker

public class RayTracerWorker {
    private let imageArray: ImageMap
    private let world: World
    private let camera: Camera
    private let configuration: TraceConfiguration
    private let intersectableTree: IntersectableTree?
    private let progressDelegate: RayTracerProgressDelegate?
    private var completion: RayTraceCompletion?
    private let traceQueue: DispatchQueue
    private let writeQueue: DispatchQueue
    private let pixelsTotal: Int
    private var pixelsRemaining: Int
    private var pixels: ImageMap.PixelSequence
    private var working = 0

    init(
        world: World,
        camera: Camera,
        configuration: TraceConfiguration,
        progressDelegate: RayTracerProgressDelegate?,
        completion: @escaping RayTraceCompletion
    ) {
        self.imageArray = ImageMap(size: camera.pixels)
        self.world = world
        self.camera = camera
        self.configuration = configuration
        self.progressDelegate = progressDelegate
        self.completion = completion
        self.pixelsTotal = camera.totalPixels
        self.pixelsRemaining = pixelsTotal
        self.intersectableTree = world.asIntersectableTree()

        traceQueue = DispatchQueue(
            label: "com.raytracer.trace-queue",
            qos: configuration.traceQoS,
            attributes: .concurrent)

        writeQueue = DispatchQueue(
            label: "com.raytracer.write-queue",
            qos: configuration.traceQoS)

        pixels = imageArray.allPixels

        for _ in 0..<configuration.maxConcurrentPixels {
            commit()
        }
    }

}

// MARK: - Commit Work

extension RayTracerWorker {

    func commit() {
        writeQueue.async {
            guard let pixel = self.pixels.next() else {
                if self.working == 0, let completion = self.completion {
                    self.completion = nil
                    completion(self.imageArray)
                }

                return
            }

            self.working += 1

            self.traceQueue.async {
                var colors = [Vector3]()

                for _ in 0..<self.configuration.effectiveAntialiasCount() {
                    let ray = self.camera.ray(
                        through: pixel,
                        applyAntialias: self.configuration.antialiasing.isOn)

                    let color = RayTracerWorker.rayTrace(
                        ray: ray,
                        tree: self.intersectableTree,
                        configuration: self.configuration,
                        scatterCount: 0)

                    colors.append(color)
                }

                guard let average = colors.average else {
                    fatalError()
                }

                let rgb = RGBColor(average, gamma: .gamma2)

                self.writeQueue.async {
                    self.imageArray.setPixel(at: pixel, rgb: rgb)
                    self.working -= 1
                    self.pixelsRemaining -= 1

                    if  let delegate = self.progressDelegate,
                        self.pixelsRemaining % 1000 == 0,
                        self.pixelsRemaining > 0
                    {
                        let pr = self.pixelsRemaining
                        let pt = self.pixelsTotal
                        let fraction = 1.0 - Double(pr) / Double(pt)

                        delegate.rayTracerWorker(
                            self,
                            pixelsRemaining: pr,
                            pixelsTotal: pt,
                            fractionCompleted: fraction)
                    }

                    self.commit()
                }
            }
        }
    }

}

// MARK: - Ray Tracing

extension RayTracerWorker {

    static func rayTrace(
        ray: Ray,
        tree: IntersectableTree?,
        configuration: TraceConfiguration,
        scatterCount: Int
    ) -> Vector3 {
        guard
            let tree = tree,
            let intersection = World.nearestIntersection(
                intersectableTree: tree,
                ray: ray,
                depthRange: configuration.depthRange)
        else {
            if let ambientColor = configuration.ambientLightVector {
                let unitDirection = ray.direction.normalised
                let t = 0.5 * (unitDirection.y + 1.0)
                return (1.0 - t) * Vector3.unit + t * ambientColor
            }

            return Vector3(0.0, 0.0, 0.0)
        }

        if let emitter = intersection.shape.emitter as? Emitting {
            let (u, v) = intersection.uvCoordinate
            let emitted = emitter.color(u: u, v: v, position: intersection.hitPoint)

            return emitted
        }

        guard scatterCount < configuration.maxScatters else {
            return Vector3.zero
        }

        guard
            let (attenuation, scatteredRay) = intersection.shape.material.scatter(
                incomingRay: ray,
                intersection: intersection)
        else {
            return Vector3.zero
        }

        guard let scatteredRay = scatteredRay else {
            return attenuation
        }

        return attenuation * rayTrace(
            ray: scatteredRay,
            tree: tree,
            configuration: configuration,
            scatterCount: scatterCount + 1)
    }

}
