struct RayTracer {
    var text = "Hello, World!"
}

typealias Radians = Double

extension Radians {

    init(degrees: Double) {
        self.init(degrees * Double.pi / 180.0)
    }

}
