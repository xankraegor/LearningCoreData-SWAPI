//
//  AppDelegate.swift
//  LearnCoreData
//
//  Created by Алексей Кудрявцев on 03/11/2017.
//  Copyright © 2017 Алексей Кудрявцев. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        reloadData()
        print(FileManager.default.urls(for: .applicationDirectory, in: .userDomainMask).last!)

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataStack.shared.saveToStore()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        CoreDataStack.shared.saveToStore()
    }

    func reloadData() {

        func perform(in context: NSManagedObjectContext, clousure: @escaping () -> ()) {
            context.perform {
                clousure()

                do {
                    if context.hasChanges {
                        try context.save()
                        debugPrint("Context changes saved")
                    }
                    else {
                        debugPrint("Context has no changes")
                    }
                }
                catch {
                    print(error)
                }
            }
        }

        let context = CoreDataStack.shared.makePrivateContext()

        SWAPI.shared.getAll(.people) { data in
            perform(in: context) {
                data.forEach { _ = People.makeOrUpdate(from: $0, in: context) }
            }
        }

        SWAPI.shared.getAll(.planets) { data in
            perform(in: context) {
                data.forEach { _ = Planet.makeOrUpdate(from: $0, in: context) }
            }
        }

        SWAPI.shared.getAll(.species) { data in
            perform(in: context) {
                data.forEach { _ = Specie.makeOrUpdate(from: $0, in: context) }
            }
        }

        SWAPI.shared.getAll(.starships) { data in
            perform(in: context) {
                data.forEach { _ = Starship.makeOrUpdate(from: $0, in: context) }
            }
        }

        SWAPI.shared.getAll(.vehicles) { data in
            perform(in: context) {
                data.forEach { _ = Vehicle.makeOrUpdate(from: $0, in: context) }
            }
        }

        SWAPI.shared.getAll(.films) { data in
            perform(in: context) {
                data.forEach { _ = Film.makeOrUpdate(from: $0, in: context) }
            }
        }

    }

}

