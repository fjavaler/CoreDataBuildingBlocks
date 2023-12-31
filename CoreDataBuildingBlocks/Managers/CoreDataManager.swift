//
//  CoreDataManager.swift
//  CoreDataBuildingBlocks
//
//  Created by Mohammad Azam on 2/21/21.
//

import Foundation
import CoreData

class CoreDataManager {
    
    lazy var managedObjectModel: NSManagedObjectModel = {
       
        guard let url = Bundle.main.url(forResource: "CoreDataBlocksModel", withExtension: "momd") else {
            fatalError("Failed to locate the CoreDataBlocksModel file!")
        }
        
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model!")
        }
        
        return model
        
    }()
    
    lazy var coordinator: NSPersistentStoreCoordinator = {
       
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let sqlitePath = documentsDirectory.appendingPathComponent("CoreDataBlocks.sqlite")
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: sqlitePath, options: nil)
        } catch {
            fatalError("Failed to create coordinator")
        }
        
        return coordinator
        
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
       
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
        
    }()
    
    func saveMovie(title: String) {
        
        let movie = Movie(context: viewContext)
        movie.title = title
        
        do {
            try viewContext.save()
        } catch {
            print("\(error)")
        }
        
    }
    
    
}
