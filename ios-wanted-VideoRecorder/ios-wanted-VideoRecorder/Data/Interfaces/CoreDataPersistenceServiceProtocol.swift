//
//  CoreDataPersistenceServiceProtocol.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/09.
//
import CoreData

protocol CoreDataPersistenceServiceProtocol {
    var context: NSManagedObjectContext? { get }
}
