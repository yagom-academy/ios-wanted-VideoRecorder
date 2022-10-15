//
//  File.swift
//  VideoRecorder
//
//  Created by sokol on 2022/10/11.
//

import Foundation

//TODO: RepositoryProtocol 대신 useCase?
protocol RepositoryProtocol: FireBaseManagerProtocol, CoreDataManagerProtocol, FileManagerProtocol {
    
}

protocol FireBaseManagerProtocol {
    
    //var fireBaseManager: ??? { get set }
    
}

protocol CoreDataManagerProtocol {
    
    associatedtype dataType
    
    var coreDataManager: CoreDataManager { get set }
    
    // TODO: async await 처리
    func fetchFromCoreData() -> [dataType]
    func insertToCoreData(_ model: dataType)
    func deleteFromCoreData(_ model: dataType)
    
}

// TODO: make file model for return + save
protocol FileManagerProtocol {
    
    var fileManager: FileManager { get set }
    
    func fetchFromFileManager(fileName name: String) throws -> VideoFile
    func saveToFileManager(file: VideoFile) throws
    func deleteFromFileManager(fileName name: String) throws
}

class Repository: RepositoryProtocol {
    
    var coreDataManager: CoreDataManager = CoreDataManager.shared
    var fileManager: FileManager = FileManager.default
    
    private var httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
}

extension Repository: FireBaseManagerProtocol {
    
}

extension Repository: CoreDataManagerProtocol {

    func fetchFromCoreData() -> [VideoModel] {
        let data = coreDataManager.fetchData()
        return data
    }
    
    func insertToCoreData(_ model: VideoModel) {
        coreDataManager.saveData(model)
    }
    
    func deleteFromCoreData(_ model: VideoModel) {
        coreDataManager.removeData(model)
    }
}

extension Repository: FileManagerProtocol {
    func fetchFromFileManager(fileName name: String) throws -> VideoFile {
        let result = try fileManager.load(name: name)
        return result
    }
    
    func saveToFileManager(file: VideoFile) throws {
        _ = try fileManager.save(file: file)
        return
    }
    
    func deleteFromFileManager(fileName name: String) throws {
        _ = try fileManager.remove(name: name)
        return
    }
    
}
