//
//  AbstractVehicle+CoreDataClass.swift
//  LearnCoreData
//
//  Created by Алексей Кудрявцев on 07/11/2017.
//  Copyright © 2017 Алексей Кудрявцев. All rights reserved.
//
//

import Foundation
import CoreData

@objc(AbstractVehicle)
public class AbstractVehicle: NSManagedObject {

    static func abstractMake<T: AbstractVehicle>(object: T, from json: JSON, in context: NSManagedObjectContext) {

        object.name = json["name"].stringValue
        object.model = json["model"].stringValue
        object.manufacturer = json["manufacturer"].stringValue
        object.costInCredits = json["cost_in_credits"].int64Value
        object.length = json["length"].floatValue
        object.maxAtmospheringSpeed = json["max_atmosphering_speed"].int64Value
        object.crew = json["crew"].int64Value
        object.passengers = json["passengers"].int64Value
        object.cargoCapacity = json["cargo_capacity"].int64Value
        object.consumables = json["consumables"].stringValue
        object.pilotIds = json["pilots"].array?.flatMap { $0.url?.lastPathComponent.asInt }
        object.created = Date.fromISO8601(json["created"].stringValue) as NSDate?
        object.edited = Date.fromISO8601(json["edited"].stringValue) as NSDate?
    }

}

