//
//  Vehicle+CoreDataClass.swift
//  LearnCoreData
//
//  Created by Алексей Кудрявцев on 07/11/2017.
//  Copyright © 2017 Алексей Кудрявцев. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Vehicle)
public final class Vehicle: AbstractVehicle {
    
    static func makeOrUpdate(from json: JSON, in context: NSManagedObjectContext) -> Vehicle? {
        guard let objectId = json["url"].url?.lastPathComponent.asInt16 else { return nil }
        let object = Vehicle(entity: entity(), insertInto: context)
        
        object.created = Date.fromISO8601(json["created"].stringValue) as NSDate?
        object.edited = Date.fromISO8601(json["edited"].stringValue) as NSDate?
        object.filmIds = json["films"].array?.flatMap { $0.url?.lastPathComponent.asInt }
        object.name = json["name"].string
        object.id = objectId
        
        object.cargoCapacity = json["cargo_capacity"].int64 ?? -1
        object.consumables = json["consumables"].string
        object.costInCredits = json["cost_in_credits"].int64 ?? -1
        object.crew = json["crew"].int64 ?? -1
        object.length = json["length"].float ?? -1
        object.manufacturer = json["manufacturer"].string
        object.maxAtmospheringSpeed = json["max_atmosphering_speed"].int64 ?? -1
        object.model = json["model"].string
        object.passengers = json["passengers"].int64 ?? -1
        object.pilotIds = json["pilots"].array?.flatMap { $0.url?.lastPathComponent.asInt }
        object.vehicleClass = json["vehicle_class"].string
        object.filmIds = json["films"].array?.flatMap { $0.url?.lastPathComponent.asInt }
        
        debugPrint("Object created: \(type(of: self)) \(objectId)")

        object.updateRelationships()
        
        return object
    }

    private static func getUniqueInstance(from id: Int16, in context: NSManagedObjectContext) -> Vehicle {
        typealias Entity = Vehicle

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
        updatePilotRelationships()
        updateFilmsRelationships()
    }

    private func updatePilotRelationships() {
        typealias Entity = People

        let request: NSFetchRequest<Entity> = Entity.fetchRequest()

        do {
            try request.execute()
                .filter {
                    let shouldBinded = $0.starshipIds?.contains(id.toInt) == true
                    let notBinded = ($0.vehicles as? Set<Vehicle>)?.first { $0.id == id } == nil
                    return shouldBinded && notBinded
                }
                .forEach {
                    $0.addToVehicles(self)
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
                    let shouldBinded = $0.vehiclesIds?.contains(id.toInt) == true
                    let notBinded = ($0.vehicles as? Set<People>)?.first { $0.id == id } == nil
                    return shouldBinded && notBinded
                }
                .forEach {
                    $0.addToVehicles(self)
                    debugPrint("Make relationship \(type(of: self)) (\(name ?? ""))) <=> \(type(of: $0)) (\($0.title ?? ""))")
            }
        }
        catch {
            debugPrint("Could not make relationship \(type(of: self)) <=> \(Entity.self))")
        }
    }
}
