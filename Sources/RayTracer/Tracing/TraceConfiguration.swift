import Foundation

// MARK: - Trace Configuration

public struct TraceConfiguration {

    /// If set provides a background gradient of ambient light based on
    /// the given rgb colour, otherwise the scene is responsible for it's
    /// own illumination.
    public var ambientLightColor: (Double, Double, Double)? = nil {
        didSet {
            if let (r, g, b) = ambientLightColor {
                ambientLightVector = Vector3(r, g, b)
            } else {
                ambientLightVector = nil
            }
        }
    }

    /// An internal Vector3 representation of the configured ambient
    /// light colour.
    var ambientLightVector: Vector3?

    /// The antialiasing policy for the trace.
    public var antialiasing = Antialiasing.off

    /// The allowed range of intersection distances. Intersections that
    /// are outside of this range will not be recognised.
    public var depthRange = 0.001..<Double.greatestFiniteMagnitude

    /// The maximum number of pixels to process concurrently.
    public var maxConcurrentPixels = 16

    /// The maximum number of times that a ray can be scattered.
    public var maxScatters = 50

    /// The quality of service class to use for the trace.
    public var traceQoS = DispatchQoS.userInitiated

    public init() {}

}

// MARK: - Antialiasing

extension TraceConfiguration {

    func effectiveAntialiasCount() -> Int {
        switch self.antialiasing {
        case .off: return 1
        case .on(let count): return max(count, 1)
        }
    }

}
