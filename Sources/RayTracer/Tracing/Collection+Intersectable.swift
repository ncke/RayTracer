import Foundation

extension Collection where Element == Intersectable {

    func nearestIntersection(
        ray: Ray,
        tRange: Range<Double>
    ) -> Intersection? {
        var nearest: Intersection?

        for element in self {
            guard
                let intersects = element.intersect(ray: ray, tRange: tRange)
            else {
                continue
            }

            if  let sofar = nearest,
                intersects.hitDistance < sofar.hitDistance
            {
                nearest = intersects

            } else if nearest == nil {
                nearest = intersects
            }
        }

        return nearest
    }

}
