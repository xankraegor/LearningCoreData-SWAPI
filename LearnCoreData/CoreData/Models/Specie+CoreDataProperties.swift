//
//  Specie+CoreDataProperties.swift
//  LearnCoreData
//
//  Created by Xan Kraegor on 03.02.2018.
//  Copyright © 2018 Алексей Кудрявцев. All rights reserved.
//
//

import Foundation
import CoreData


extension Specie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Specie> {
        return NSFetchRequest<Specie>(entityName: "Specie")
    }

    @NSManaged public var averageHeight: Int16
    @NSManaged public var averageLifespan: Int16
    @NSManaged public var classification: String?
    @NSManaged public var created: NSDate?
    @NSManaged public var designation: String?
    @NSManaged public var edited: NSDate?
    @NSManaged public var eyeColors: [String]?
    @NSManaged public var filmIds: [Int]?
    @NSManaged public var hairColors: [String]?
    @NSManaged public var homeworldId: Int16
    @NSManaged public var id: Int16
    @NSManaged public var language: String?
    @NSManaged public var name: String?
    @NSManaged public var peopleIds: [Int]?
    @NSManaged public var skinColors: [String]?
    @NSManaged public var films: NSSet?
    @NSManaged public var homeworld: Planet?
    @NSManaged public var peoples: NSSet?

}

// MARK: Generated accessors for films
extension Specie {

    @objc(addFilmsObject:)
    @NSManaged public func addToFilms(_ value: Film)

    @objc(removeFilmsObject:)
    @NSManaged public func removeFromFilms(_ value: Film)

    @objc(addFilms:)
    @NSManaged public func addToFilms(_ values: NSSet)

    @objc(removeFilms:)
    @NSManaged public func removeFromFilms(_ values: NSSet)

}

// MARK: Generated accessors for peoples
extension Specie {

    @objc(addPeoplesObject:)
    @NSManaged public func addToPeoples(_ value: People)

    @objc(removePeoplesObject:)
    @NSManaged public func removeFromPeoples(_ value: People)

    @objc(addPeoples:)
    @NSManaged public func addToPeoples(_ values: NSSet)

    @objc(removePeoples:)
    @NSManaged public func removeFromPeoples(_ values: NSSet)

}
