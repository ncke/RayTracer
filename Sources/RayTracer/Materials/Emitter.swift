import Foundation

// MARK: - Emitter

public class Emitter {}

// MARK: - Emitting

protocol Emitting {

    func color(u: Double, v: Double, position: Vector3) -> Vector3

}
