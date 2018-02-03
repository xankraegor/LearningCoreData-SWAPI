//
//  Film+CoreDataClass.swift
//  LearnCoreData
//
//  Created by Xan Kraegor on 03.02.2018.
//  Copyright © 2018 Алексей Кудрявцев. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Film)
public class Film: NSManagedObject {

    static func makeOrUpdate(from json: JSON, in context: NSManagedObjectContext) -> Film? {
        guard let objectId = json["url"].url?.lastPathComponent.asInt16 else { return nil }
        let object = getUniqueInstance(from: objectId, in: context)
        object.created = Date.fromISO8601(json["created"].stringValue) as NSDate?
        object.edited = Date.fromISO8601(json["edited"].stringValue) as NSDate?
        object.id = objectId

        object.title = json["title"].string
        object.episode_id = json["episode_id"].int16 ?? -1
        object.opening_crawl = json["opening_crawl"].string
        object.director = json["director"].string
        object.producer = json["producer"].string
        object.release_date = Date.fromISO8601(json["release_date"].stringValue) as NSDate?

        object.speciesIds = json["species"].array?.flatMap { $0.url?.lastPathComponent.asInt }
        object.starshipsIds = json["starships"].array?.flatMap { $0.url?.lastPathComponent.asInt }
        object.vehiclesIds = json["vehicles"].array?.flatMap { $0.url?.lastPathComponent.asInt }
        object.charactersIds = json["characters"].array?.flatMap { $0.url?.lastPathComponent.asInt }
        object.planetsIds = json["planets"].array?.flatMap { $0.url?.lastPathComponent.asInt }

        object.updateRelationships()

        debugPrint("Object created: \(type(of: self)) \(objectId)")

        return object
    }

    private static func getUniqueInstance(from id: Int16, in context: NSManagedObjectContext) -> Film {
        typealias Entity = Film

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
        updateSpeciesRelationships()
        updateStarshipsRelationships()
        updateVehiclesRelationships()
        updateCharactersRelationships()
        updatePlanetsRelationships()
    }

    private func updateSpeciesRelationships() {
        typealias Entity = Specie

        let request: NSFetchRequest<Entity> = Entity.fetchRequest()

        do {
            try request.execute()
                .filter {
                    let shouldBinded = $0.filmIds?.contains(id.toInt) == true
                    let notBinded = ($0.films as? Set<People>)?.first { $0.id == id } == nil
                    return shouldBinded && notBinded
                }
                .forEach {
                    $0.addToFilms(self)
                    debugPrint("Make relationship \(type(of: self)) (\(title ?? ""))) <=> \(type(of: $0)) (\($0.name ?? ""))")
            }
        }
        catch {
            debugPrint("Could not make relationship \(type(of: self)) <=> \(Entity.self))")
        }
    }

    private func updateStarshipsRelationships() {
        typealias Entity = Starship

        let request: NSFetchRequest<Entity> = Entity.fetchRequest()

        do {
            try request.execute()
                .filter {
                    let shouldBinded = $0.filmIds?.contains(id.toInt) == true
                    let notBinded = ($0.films as? Set<People>)?.first { $0.id == id } == nil
                    return shouldBinded && notBinded
                }
                .forEach {
                    $0.addToFilms(self)
                    debugPrint("Make relationship \(type(of: self)) (\(title ?? ""))) <=> \(type(of: $0)) (\($0.name ?? ""))")
            }
        }
        catch {
            debugPrint("Could not make relationship \(type(of: self)) <=> \(Entity.self))")
        }
    }

    private func updateVehiclesRelationships() {
        typealias Entity = Vehicle

        let request: NSFetchRequest<Entity> = Entity.fetchRequest()

        do {
            try request.execute()
                .filter {
                    let shouldBinded = $0.filmIds?.contains(id.toInt) == true
                    let notBinded = ($0.films as? Set<People>)?.first { $0.id == id } == nil
                    return shouldBinded && notBinded
                }
                .forEach {
                    $0.addToFilms(self)
                    debugPrint("Make relationship \(type(of: self)) (\(title ?? ""))) <=> \(type(of: $0)) (\($0.name ?? ""))")
            }
        }
        catch {
            debugPrint("Could not make relationship \(type(of: self)) <=> \(Entity.self))")
        }
    }

    private func updateCharactersRelationships() {
        typealias Entity = People

        let request: NSFetchRequest<Entity> = Entity.fetchRequest()

        do {
            try request.execute()
                .filter {
                    let shouldBinded = $0.filmIds?.contains(id.toInt) == true
                    let notBinded = ($0.films as? Set<People>)?.first { $0.id == id } == nil
                    return shouldBinded && notBinded
                }
                .forEach {
                    $0.addToFilms(self)
                    debugPrint("Make relationship \(type(of: self)) (\(title ?? ""))) <=> \(type(of: $0)) (\($0.name ?? ""))")
            }
        }
        catch {
            debugPrint("Could not make relationship \(type(of: self)) <=> \(Entity.self))")
        }
    }

    private func updatePlanetsRelationships() {
        typealias Entity = Planet

        let request: NSFetchRequest<Entity> = Entity.fetchRequest()

        do {
            try request.execute()
                .filter {
                    let shouldBinded = $0.filmIds?.contains(id.toInt) == true
                    let notBinded = ($0.films as? Set<People>)?.first { $0.id == id } == nil
                    return shouldBinded && notBinded
                }
                .forEach {
                    $0.addToFilms(self)
                    debugPrint("Make relationship \(type(of: self)) (\(title ?? ""))) <=> \(type(of: $0)) (\($0.name ?? ""))")
            }
        }
        catch {
            debugPrint("Could not make relationship \(type(of: self)) <=> \(Entity.self))")
        }
    }

}
