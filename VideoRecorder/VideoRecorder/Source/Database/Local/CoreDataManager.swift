//
//  CoreDataManager.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/08.
//

import CoreData

final class CoreDataManager {
    enum Constant {
        static let container = "CoreData"
        static let searchCondition = "identifier == %@"
    }
    
    static let shared = CoreDataManager()
    
    private init() { }
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constant.container)
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    private var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    func create<DAO: NSManagedObject & DataAccessObject, DTO: DataTransferObject>(type: DAO.Type, data: DTO) where DTO == DAO.DataTransferObject {
        guard let entityName = DAO.entity().name,
              let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            return
            
        }
        
        let storage = DAO(entity: entityDescription, insertInto: context)
        storage.setValues(from: data)
        
        save()
    }
    
    func read<DAO: NSManagedObject & DataAccessObject>(type: DAO.Type) -> [DAO]? {
        guard let entityName = DAO.entity().name else { return nil }
        
        let fetchRequest = NSFetchRequest<DAO>(entityName: entityName)
        
        do {
            let fetchedData = try context.fetch(fetchRequest)
            
            return fetchedData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func update<DAO: NSManagedObject & DataAccessObject, DTO: DataTransferObject>(type: DAO.Type, data: DTO) where DTO == DAO.DataTransferObject {
        guard let storage = search(type: type, by: data.identifier) else { return }
        
        storage.updateValues(from: data)
        
        save()
    }
    
    func delete<DAO: NSManagedObject & DataAccessObject, DTO: DataTransferObject>(type: DAO.Type, data: DTO) {
        guard let storage = search(type: type, by: data.identifier) else { return }
        
        context.delete(storage)
        
        save()
    }
    
    private func search<DAO: NSManagedObject & DataAccessObject>(type: DAO.Type, by identifier: UUID) -> DAO? {
        guard let entityName = DAO.entity().name else { return nil }
        
        let fetchRequest = NSFetchRequest<DAO>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: Constant.searchCondition, identifier.uuidString)
        
        do {
            let fetchedData = try context.fetch(fetchRequest)
            return fetchedData.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func save() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
