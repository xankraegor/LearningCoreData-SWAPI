//
//  Planet+CoreDataClass.swift
//  LearnCoreData
//
//  Created by Алексей Кудрявцев on 07/11/2017.
//  Copyright © 2017 Алексей Кудрявцев. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Planet)
public final class Planet: NSManagedObject {

    static func makeOrUpdate(from json: JSON, in context: NSManagedObjectContext) -> Planet? {
        guard let objectId = json["url"].url?.lastPathComponent.asInt16 else { return nil }
        let object = getUniqueInstance(from: objectId, in: context)
        
        object.created = Date.fromISO8601(json["created"].stringValue) as NSDate?
        object.edited = Date.fromISO8601(json["edited"].stringValue) as NSDate?
        object.filmIds = json["films"].array?.flatMap { $0.url?.lastPathComponent.asInt }
        object.name = json["name"].string
        object.id = objectId
        
        object.climate = json["climate"].string
        object.diameter = json["diameter"].int32 ?? -1
        object.gravity = json["gravity"].string
        object.orbitalPeriod = json["orbital_period"].int16 ?? -1
        object.population = json["population"].int64 ?? -1
        object.residentIds = json["residents"].array?.flatMap { $0.url?.lastPathComponent.asInt }
        object.rotationPeriod = json["rotation_period"].int16 ?? -1
        object.surfaceWater = json["surface_water"].int16 ?? -1
        object.terrain = json["terrain"].string
        object.filmIds = json["films"].array?.flatMap { $0.url?.lastPathComponent.asInt }

        object.updateRelationships()
    
        debugPrint("Object created: \(type(of: self)) \(objectId)")
        
        return object
    }

    private static func getUniqueInstance(from id: Int16, in context: NSManagedObjectContext) -> Planet {
        typealias Entity = Planet

        let request: NSFetchRequest<Entity> = fetchRequest()
        request.predicate = NSPredicate(format: "id = %i", id)

        let results = try? request.execute()

        guard let existing = results?.first else {
            debugPrint("Object created: \(Entity.self) \(id)")
            return Entity(entity: entity(), insertInto: context)
        }

        return existing
    }

    func updateRelationships() {
        updateResidentRelationships()
        updateFilmsRelationships()
    }

    private func updateResidentRelationships() {
        typealias Entity = People

        let request: NSFetchRequest<Entity> = Entity.fetchRequest()

        do {
            try request.execute()
                .filter {
                    let shouldBinded = $0.homeworldId == id.toInt
                    let notBinded = $0.homeworld == nil
                    return shouldBinded && notBinded
                }
                .forEach {
                    $0.homeworld = self
                    debugPrint("Make relationship \(type(of: self)) (\(name ?? ""))) <=> \(type(of: $0)) (\($0.name ?? ""))")
            }
        }
        catch {
            debugPrint("Could not make relationship \(type(of: self)) <=> \(Entity.self))")
        }
    }

    func updateFilmsRelationships() {
        typealias Entity = Film

        let request: NSFetchRequest<Entity> = Entity.fetchRequest()

        do {
            try request.execute()
                .filter {
                    let shouldBinded = $0.planetsIds?.contains(id.toInt) == true
                    let notBinded = ($0.planets as? Set<People>)?.first { $0.id == id } == nil
                    return shouldBinded && notBinded
                }
                .forEach {
                    $0.addToPlanets(self)
                    debugPrint("Make relationship \(type(of: self)) (\(name ?? ""))) <=> \(type(of: $0)) (\($0.title ?? ""))")
            }
        }
        catch {
            debugPrint("Could not make relationship \(type(of: self)) <=> \(Entity.self))")
        }
    }
}
