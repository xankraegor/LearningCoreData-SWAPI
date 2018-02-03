//
//  Planet+CoreDataProperties.swift
//  LearnCoreData
//
//  Created by Xan Kraegor on 03.02.2018.
//  Copyright © 2018 Алексей Кудрявцев. All rights reserved.
//
//

import Foundation
import CoreData


extension Planet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Planet> {
        return NSFetchRequest<Planet>(entityName: "Planet")
    }

    @NSManaged public var climate: String?
    @NSManaged public var created: NSDate?
    @NSManaged public var diameter: Int32
    @NSManaged public var edited: NSDate?
    @NSManaged public var filmIds: [Int]?
    @NSManaged public var gravity: String?
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var orbitalPeriod: Int16
    @NSManaged public var population: Int64
    @NSManaged public var residentIds: [Int]?
    @NSManaged public var rotationPeriod: Int16
    @NSManaged public var surfaceWater: Int16
    @NSManaged public var terrain: String?
    @NSManaged public var films: NSSet?
    @NSManaged public var residents: NSSet?

}

// MARK: Generated accessors for films
extension Planet {

    @objc(addFilmsObject:)
    @NSManaged public func addToFilms(_ value: Film)

    @objc(removeFilmsObject:)
    @NSManaged public func removeFromFilms(_ value: Film)

    @objc(addFilms:)
    @NSManaged public func addToFilms(_ values: NSSet)

    @objc(removeFilms:)
    @NSManaged public func removeFromFilms(_ values: NSSet)

}

// MARK: Generated accessors for residents
extension Planet {

    @objc(addResidentsObject:)
    @NSManaged public func addToResidents(_ value: People)

    @objc(removeResidentsObject:)
    @NSManaged public func removeFromResidents(_ value: People)

    @objc(addResidents:)
    @NSManaged public func addToResidents(_ values: NSSet)

    @objc(removeResidents:)
    @NSManaged public func removeFromResidents(_ values: NSSet)

}
