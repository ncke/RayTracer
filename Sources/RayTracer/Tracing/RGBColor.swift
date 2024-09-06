import Foundation

// MARK: - Color Vector

struct RGBColor {
    let red: Int
    let green: Int
    let blue: Int

    init(_ red: Int, _ green: Int, _ blue: Int) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    init(_ red: Double, _ green: Double, _ blue: Double) {
        self.red = Int(255.99 * red)
        self.green = Int(255.99 * green)
        self.blue = Int(255.99 * blue)
    }

    init(_ vector: Vector3) {
        self.init(vector.x, vector.y, vector.z)
    }

}

// MARK: - Gamma

extension RGBColor {

    enum Gamma {
        case gamma2
    }

    init(_ vector: Vector3, gamma: Gamma) {
        switch gamma {
        case .gamma2:
            self.init(sqrt(vector.x), sqrt(vector.y), sqrt(vector.z))
        }
    }

}

// MARK: - Black

extension RGBColor {

    static let black = RGBColor(0, 0, 0)

}
