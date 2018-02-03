//
//  Starship+CoreDataProperties.swift
//  LearnCoreData
//
//  Created by Xan Kraegor on 03.02.2018.
//  Copyright © 2018 Алексей Кудрявцев. All rights reserved.
//
//

import Foundation
import CoreData


extension Starship {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Starship> {
        return NSFetchRequest<Starship>(entityName: "Starship")
    }

    @NSManaged public var filmIds: [Int]?
    @NSManaged public var hyperdriveRating: Float
    @NSManaged public var mglt: Int16
    @NSManaged public var starshipClass: String?
    @NSManaged public var films: NSSet?
    @NSManaged public var pilots: NSSet?

}

// MARK: Generated accessors for films
extension Starship {

    @objc(addFilmsObject:)
    @NSManaged public func addToFilms(_ value: Film)

    @objc(removeFilmsObject:)
    @NSManaged public func removeFromFilms(_ value: Film)

    @objc(addFilms:)
    @NSManaged public func addToFilms(_ values: NSSet)

    @objc(removeFilms:)
    @NSManaged public func removeFromFilms(_ values: NSSet)

}

// MARK: Generated accessors for pilots
extension Starship {

    @objc(addPilotsObject:)
    @NSManaged public func addToPilots(_ value: People)

    @objc(removePilotsObject:)
    @NSManaged public func removeFromPilots(_ value: People)

    @objc(addPilots:)
    @NSManaged public func addToPilots(_ values: NSSet)

    @objc(removePilots:)
    @NSManaged public func removeFromPilots(_ values: NSSet)

}
