//  ViewPlaneTests.swift
//  Created by Nick on 03/01/2021.

import XCTest
@testable import RayTracer

final class ViewPlaneTests: RayTracerTestCase {

    func testEyeRay() {
        let vp = ViewPlane(
            eye: Point.zero,
            distance: 10.0,
            gaze: Vector(0.0, 0.0, 1.0),
            up: Vector(0.0, 1.0, 0.0),
            theta: Radians(degrees: 20.0),
            phi: Radians(degrees: 20.0),
            imageWidth: 200.0,
            imageHeight: 200.0
        )

        let ray1 = vp.eyeRay(forScreenX: 100, screenY: 100)

        let expectation1 = Ray(
            origin: Point.zero,
            direction: Vector(0.0, 0.0, 1.0)
        )
        AssertEqualRay(ray1, expectation1)

        let ray2 = vp.eyeRay(forScreenX: 0, screenY: 0)

        let expectation2 = Ray(
            origin: Point.zero,
            direction: Vector(
                0.32361557711818467,
                -0.32361557711818467,
                0.8891264907159884
            )
        )
        AssertEqualRay(ray2, expectation2)

        let ray3 = vp.eyeRay(forScreenX: 200, screenY: 200)

        let expectation3 = Ray(
            origin: Point.zero,
            direction: Vector(
                -0.32361557711818467,
                0.32361557711818467,
                0.8891264907159884
            )
        )
        AssertEqualRay(ray3, expectation3)
    }

    static var allTests = [
        ("testEyeRay", testEyeRay),
    ]

}
