import Foundation

// MARK: - Dielectric Scattering

struct DielectricScattering {

    private static let unattenuated = Vector3(1.0, 1.0, 1.0)

    static func scatter(
        refractiveIndex: RefractiveIndex,
        isFrontFace: Bool,
        incomingRay: Ray,
        intersection: Intersection
    ) -> (Vector3, Ray)? {

        let index = isFrontFace ?
            1.0 / refractiveIndex.index : refractiveIndex.index

        let refracted = incomingRay.direction.refracted(
            normal: intersection.normal,
            refractiveIndex: index)

        let attenuation = DielectricScattering.unattenuated

        let scattered = Ray(
            origin: intersection.hitPoint,
            direction: refracted)

        return (attenuation, scattered)
    }

}
