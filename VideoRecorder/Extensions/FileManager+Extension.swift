//
//  FileManager+Extension.swift
//  VideoRecorder
//
//  Created by pablo.jee on 2022/10/13.
//

import Foundation

extension FileManager {
    enum FileManagerError: Error {
        case directoryError
        case loadError
        case saveError
        case deleteError
    }
    // TODO: make model to return
    // TODO: async await
    func load(name: String) throws -> VideoFile {
        let documentURL = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentURL.appendingPathComponent("videoData")
        let fileURL = directoryURL.appendingPathComponent("\(name).json")
        
        guard !FileManager.default.fileExists(atPath: "\(fileURL)") else { throw FileManagerError.loadError }
        
        do {
            let jsonDecoder = JSONDecoder()
            let jsonData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
            let decodeJson = try jsonDecoder.decode(VideoFile.self, from: jsonData)
            return decodeJson
        } catch {
            throw FileManagerError.loadError
        }
    }
    
    func save(file: VideoFile) throws {
        let documentURL = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentURL.appendingPathComponent("videoData")
        let fileURL = directoryURL.appendingPathComponent("\(file.fileName).json")
        var isDir: ObjCBool = true
        
        if !FileManager.default.fileExists(atPath: "\(directoryURL)", isDirectory: &isDir) {
            do {
                try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            } catch {
                throw FileManagerError.directoryError
            }
        }
        
        do {
            let jsonEncoder = JSONEncoder()
            let encodedData = try jsonEncoder.encode(file)
            print(String(data: encodedData, encoding: .utf8)!)
            try encodedData.write(to: fileURL)
            return
        } catch {
            throw FileManagerError.saveError
        }
    }
    
    @discardableResult
    func remove(name: String) throws -> Bool {
        let documentURL = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentURL.appendingPathComponent("videoData")
        let fileURL = directoryURL.appendingPathComponent("\(name).json")
        
        guard !FileManager.default.fileExists(atPath: "\(fileURL)") else {
            throw FileManagerError.deleteError
        }
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            return true
        } catch {
            throw FileManagerError.deleteError
        }
    }
}
