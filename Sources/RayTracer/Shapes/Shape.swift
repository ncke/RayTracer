import Foundation

// MARK: - Shape

public protocol Shape {

    var material: Material { get }

    var emitter: Emitter? { get }

}
