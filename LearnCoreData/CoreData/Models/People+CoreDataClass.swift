//
//  People+CoreDataClass.swift
//  LearnCoreData
//
//  Created by Алексей Кудрявцев on 07/11/2017.
//  Copyright © 2017 Алексей Кудрявцев. All rights reserved.
//
//

import Foundation
import CoreData

@objc(People)
public final class People: NSManagedObject {
    
    static func makeOrUpdate(from json: JSON, in context: NSManagedObjectContext) -> People? {
        guard let objectId = json["url"].url?.lastPathComponent.asInt16 else { return nil }
        let object = getUniqueInstance(from: objectId, in: context)
        
        object.created = Date.fromISO8601(json["created"].stringValue) as NSDate?
        object.edited = Date.fromISO8601(json["edited"].stringValue) as NSDate?
        object.filmIds = json["films"].array?.flatMap { $0.url?.lastPathComponent.asInt }
        object.name = json["name"].string
        object.id = objectId
        
        object.birthYear = json["birth_year"].string
        object.eyeColor = json["eye_color"].string
        object.gender = json["gender"].string
        object.hairColor = json["hair_color"].string
        object.height = json["height"].int16 ?? -1
        object.homeworldId = json["homeworld"].url?.lastPathComponent.asInt16 ?? -1
        object.mass = json["mass"].int32 ?? -1
        object.skinColor = json["skin_color"].string
        object.specieIds = json["species"].array?.flatMap { $0.url?.lastPathComponent.asInt }
        object.starshipIds = json["starships"].array?.flatMap { $0.url?.lastPathComponent.asInt }
        object.vehicleIds = json["vehicles"].array?.flatMap { $0.url?.lastPathComponent.asInt }
        object.filmIds = json["films"].array?.flatMap { $0.url?.lastPathComponent.asInt }
    
        object.updateRelationships()
        
        return object
    }
    
    private static func getUniqueInstance(from id: Int16, in context: NSManagedObjectContext) -> People {
        typealias Entity = People

        let request: NSFetchRequest<Entity> = fetchRequest()
        request.predicate = NSPredicate(format: "id = %i", id)
        
        let results = try? request.execute()
        
        guard let exidted = results?.first else {
            debugPrint("Object created: \(Entity.self) \(id)")
            return Entity(entity: entity(), insertInto: context)
        }
        
        return exidted
    }
    
    func updateRelationships() {
        updateHomeworldRelationships()
        updateVehicleRelationships()
        updateStarshipRelationships()
        updateSpecieRelationships()
        updateFilmsRelationships()
    }
    
    private func updateHomeworldRelationships() {
        typealias Entity = Planet

        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        
        do {
            try request.execute()
                .filter {
                    let shouldBinded = $0.residentIds?.contains(id.toInt) == true
                    let notBinded = ($0.residents as? Set<People>)?.first { $0.id == id } == nil
                    return shouldBinded && notBinded
                }
                .forEach {
                    $0.addToResidents(self)
                    debugPrint("Make relationship \(type(of: self)) (\(name ?? ""))) <=> \(type(of: $0)) (\($0.name ?? ""))")
            }
        }
        catch {
            debugPrint("Could not make relationship \(type(of: self)) <=> \(Entity.self))")
        }
    }
    
    private func updateVehicleRelationships() {
        typealias Entity = Vehicle
        
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        
        do {
            try request.execute()
                .filter {
                    let shouldBinded = $0.pilotIds?.contains(id.toInt) == true
                    let notBinded = ($0.pilots as? Set<People>)?.first { $0.id == id } == nil
                    return shouldBinded && notBinded
                }
                .forEach {
                    $0.addToPilots(self)
                    debugPrint("Make relationship \(type(of: self)) (\(name ?? ""))) <=> \(type(of: $0)) (\($0.name ?? ""))")
            }
        }
        catch {
            debugPrint("Could not make relationship \(type(of: self)) <=> \(Entity.self))")
        }
    }
    
    private func updateStarshipRelationships() {
        typealias Entity = Starship
        
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        
        do {
            try request.execute()
                .filter {
                    let shouldBinded = $0.pilotIds?.contains(id.toInt) == true
                    let notBinded = ($0.pilots as? Set<People>)?.first { $0.id == id } == nil
                    return shouldBinded && notBinded
                }
                .forEach {
                    $0.addToPilots(self)
                    debugPrint("Make relationship \(type(of: self)) (\(name ?? ""))) <=> \(type(of: $0)) (\($0.name ?? ""))")
            }
        }
        catch {
            debugPrint("Could not make relationship \(type(of: self)) <=> \(Entity.self))")
        }
    }
    
    private func updateSpecieRelationships() {
        typealias Entity = Specie
        
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        
        do {
            try request.execute()
                .filter {
                    let shouldBinded = $0.peopleIds?.contains(id.toInt) == true
                    let notBinded = ($0.peoples as? Set<People>)?.first { $0.id == id } == nil
                    return shouldBinded && notBinded
                }
                .forEach {
                    $0.addToPeoples(self)
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
                    let shouldBinded = $0.charactersIds?.contains(id.toInt) == true
                    let notBinded = ($0.characters as? Set<People>)?.first { $0.id == id } == nil
                    return shouldBinded && notBinded
                }
                .forEach {
                    $0.addToCharacters(self)
                    debugPrint("Make relationship \(type(of: self)) (\(name ?? ""))) <=> \(type(of: $0)) (\($0.title ?? ""))")
            }
        }
        catch {
            debugPrint("Could not make relationship \(type(of: self)) <=> \(Entity.self))")
        }
    }
}
