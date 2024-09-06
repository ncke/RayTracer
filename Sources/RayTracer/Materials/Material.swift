import Foundation

// MARK: - Material

public enum Material {
    case lambertian(texture: Texture)
    case metal(albedo: Albedo, fuzziness: Double)
    case dielectric(refractiveIndex: RefractiveIndex)
    case nonscattering
}

// MARK: - Scattering

extension Material {

    func scatter(
        incomingRay: Ray,
        intersection: Intersection
    ) -> (Vector3, Ray?)? {

        switch self {

        case .lambertian(let texture):
            return LambertianScattering.scatter(
                texture: texture,
                incomingRay: incomingRay,
                intersection: intersection)

        case .metal(let albedo, let fuzziness):
            return MetallicScattering.scatter(
                albedo: albedo,
                fuzziness: fuzziness,
                incomingRay: incomingRay,
                intersection: intersection)

        case .dielectric(let refractiveIndex):
            return DielectricScattering.scatter(
                refractiveIndex: refractiveIndex,
                isFrontFace: intersection.isFrontFace,
                incomingRay: incomingRay,
                intersection: intersection)

        case .nonscattering:
            return nil
        }
    }

}
