import Foundation

// MARK: - Ray Tracer

public typealias RayTraceCompletion = (ImageMap) -> Void

public struct RayTracer {

    public static func trace(
        camera: Camera,
        world: World,
        configuration: TraceConfiguration,
        progressDelegate: RayTracerProgressDelegate? = nil,
        completion: @escaping RayTraceCompletion
    ) -> RayTracerWorker {

        return RayTracerWorker(
            world: world,
            camera: camera,
            configuration: configuration,
            progressDelegate: progressDelegate,
            completion: completion)
    }

}
