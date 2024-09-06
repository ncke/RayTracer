import Foundation

extension Int {

    func clamp(_ min: Int, _ max: Int) -> Int {
        self < min ? min : (self > max ? max : self)
    }

}
