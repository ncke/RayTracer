//
//  Perlin.swift
//  
//
//  Created by Nick on 05/08/2022.
//

import Foundation

// MARK: - Perlin Noise

struct Perlin {

    static let shared = Perlin()

    private let randoms: [Vector3]
    private let xPerm: [Int]
    private let yPerm: [Int]
    private let zPerm: [Int]

    private init() {
        randoms = (0..<256).map { _ in Vector3.randomUnitVector }
        xPerm = Perlin.generatePermutation()
        yPerm = Perlin.generatePermutation()
        zPerm = Perlin.generatePermutation()
    }

    private static func generatePermutation() -> [Int] {
        (0..<256).map { i in i }.shuffled()
    }

}

// MARK: - Noise Generator

extension Perlin {

    func noise(position: Vector3) -> Double {
        let floors = Vector3(
            floor(position.x),
            floor(position.y),
            floor(position.z)
        )

        let offsets = position - floors

        let locality = makeLocality(floors: floors)
        return interpolate(
            locality: locality,
            offsets: offsets
        )
    }

}

// MARK: - Trilinear Interpolation

private extension Perlin {

    typealias TrilinearLocality = [[[Vector3]]]

    func makeLocality(floors: Vector3) -> TrilinearLocality {
        let locality: TrilinearLocality =
            (0..<2).map { di in

                (0..<2).map { dj in

                    (0..<2).map { dk in

                        let i = (Int(floors.x) + di) & 255
                        let j = (Int(floors.y) + dj) & 255
                        let k = (Int(floors.z) + dk) & 255

                        let idx = xPerm[i] ^ yPerm[j] ^ zPerm[k]
                        return randoms[idx]
                    }
                }

            }

        return locality
    }

    func interpolate(locality: TrilinearLocality, offsets: Vector3) -> Double {
        let hermite = offsets.hermiteCubic
        var accum = 0.0

        for i in 0..<2 {
            for j in 0..<2 {
                for k in 0..<2 {

                    let id = Double(i)
                    let jd = Double(j)
                    let kd = Double(k)

                    let weight = Vector3(
                        offsets.x - id,
                        offsets.y - jd,
                        offsets.z - kd
                    )

                    let c = (id * hermite.x + (1.0 - id) * (1.0 - hermite.x))
                        * (jd * hermite.y + (1.0 - jd) * (1.0 - hermite.y))
                        * (kd * hermite.z + (1.0 - kd) * (1.0 - hermite.z))


                    accum += c * (locality[i][j][k] ⋅ weight)
                }
            }
        }

        return accum
    }

}

// MARK: - Turbulence

extension Perlin {

    func turbulence(position: Vector3, depth: Int = 7) -> Double {
        var accum = 0.0
        var temp = position
        var weight = 1.0

        for _ in 0..<depth {
            accum += weight * noise(position: temp)
            weight *= 0.5
            temp *= 2.0
        }

        return abs(accum)
    }

}
