//
//  AppDelegate.swift
//  Todoey
//
//  Created by Amanda Ramirez on 6/20/18.
//  Copyright © 2018 Amanda Ramirez. All rights reserved.
//

import UIKit
import CoreData 

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    // this lazy vairiable only occupies memory when it is needed.
    // this is where all of our data will be stored
    // this container is a SQLite database
    lazy var persistentContainer: NSPersistentContainer = {
        // we create a new NSPersistentContainer (SQLite database) using our CoreData DataModel
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        // a temporary area where changes are updated
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                // this is where chnages are saved to permanent storage 
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }



}

