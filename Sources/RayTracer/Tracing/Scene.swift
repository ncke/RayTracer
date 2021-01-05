//  Scene.swift
//  Created by Nick on 03/01/2021.

import Foundation

struct Scene {
    var objects: [Object]
    var lights: [LightSource]
}

extension Scene {

    func objectHit(by ray: Ray) -> (object: Object, point: Point)? {
        var nearest: (Object, Point)?
        var distance = Double.greatestFiniteMagnitude

        for object in objects {
            guard let hit = object.intersection(ray: ray) else {
                continue
            }

            let hitDistance = hit.distance(to: ray.origin)
            guard hitDistance < distance else { continue }

            nearest = (object, hit)
            distance = hitDistance
        }

        return nearest
    }

    func lightsVisible(
        from point: Point,
        on object: Object
    ) -> [LightSource]? {
        var visible = [LightSource]()

        for light in lights {
            let ray = Ray(origin: point, towards: light.center)
            let hitObject = objectHit(by: ray)?.object

            if let hitObject = hitObject, hitObject != object {
                continue
            }

            visible.append(light)
        }

        return visible.isEmpty ? nil : visible
    }

}
