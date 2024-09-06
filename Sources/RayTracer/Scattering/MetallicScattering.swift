import Foundation

// MARK: - Metallic Scattering

struct MetallicScattering {

    static func scatter(
        albedo: Albedo,
        fuzziness: Double,
        incomingRay: Ray,
        intersection: Intersection
    ) -> (Vector3, Ray)? {
        var reflected = incomingRay.direction.normalised.reflected(
            normal: intersection.normal)

        if fuzziness > Double.zero {
            let peturb = Sphere.randomInteriorPoint(radius: Sphere.unitRadius)
            reflected += fuzziness * peturb
        }

        let scattered = Ray(
            origin: intersection.hitPoint,
            direction: reflected)

        if scattered.direction ⋅ intersection.normal > Double.zero {
            let attenuation = albedo.vector
            return (attenuation, scattered)
        }

        return nil
    }

}
