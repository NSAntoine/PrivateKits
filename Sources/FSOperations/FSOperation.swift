//
//  FSOperation.swift
//  Santander
//
//  Created by Serena on 15/09/2022
//


import Foundation
import AssetCatalogWrapper
import UniformTypeIdentifiers

// You may ask, hey, why is this an enum and not a struct / class with several functions?
// well:
// 1) this allows for just one unified function, rather than many
// 2) this allows to redirect to a root helper

/// Lists operations that can be done to the FileSystem
public enum FSOperation: Codable {
    case removeItems(items: [URL])
    case createFile(files: [URL])
    case createDirectory(directories: [URL])
    
    case moveItem(items: [URL], resultPath: URL)
    case copyItem(items: [URL], resultPath: URL)
    // key: symlink path
    // value: destination path of symlink
    case symlink ([URL: URL])
    
    case setOwner(url: URL, newOwner: String)
    case setGroup(url: URL, newGroup: String)
    
    case setPermissions(url: URL, newOctalPermissions: Int)
    
    case writeData(url: URL, data: Data)
    case writeString(url: URL, string: String)
    case extractCatalog(renditions: [CodableRendition], resultPath: URL)
    
    static private let fm = FileManager.default
    
    private static func _returnFailedItemsDictionaryIfAvailable(_ urls: [URL], handler: (URL) throws -> Void) throws {
        if urls.count == 1 {
            try handler(urls[0])
            return
        }
        
        var failedItems: [String: String] = [:]
        for url in urls {
            do {
                try handler(url)
            } catch {
                failedItems[url.lastPathComponent] = error.localizedDescription
            }
        }
        
        if !failedItems.isEmpty {
            var message: String = ""
            for (item, error) in failedItems {
                message.append("\(item): \(error)\n")
            }
            
            throw _Errors.otherError(description: message.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
    
    public static func perform(_ operation: FSOperation, rootHelperConf: RootHelperConfiguration?) throws {
        if let rootHelperConf = rootHelperConf, rootHelperConf.useRootHelper {
            try rootHelperConf.action(operation)
            return
        }
       
        switch operation {
        case .removeItems(let items):
            try _returnFailedItemsDictionaryIfAvailable(items) { url in
                try fm.removeItem(at: url)
            }
            
        case .createFile(let files):
            try _returnFailedItemsDictionaryIfAvailable(files) { url in
                // mode "a": create if it doesn't exist
                guard let filePtr = fopen((url as NSURL).fileSystemRepresentation, "a") else {
                    throw _Errors.errnoError
                }
                
                fclose(filePtr)
            }
        case .createDirectory(let directories):
            try _returnFailedItemsDictionaryIfAvailable(directories) { url in
                try fm.createDirectory(at: url, withIntermediateDirectories: true)
            }
        case .moveItem(let items, let resultPath):
            try _returnFailedItemsDictionaryIfAvailable(items) { url in
                try fm.moveItem(at: url, to: resultPath.appendingPathComponent(url.lastPathComponent))
            }
        case .copyItem(let items, let resultPath):
            try _returnFailedItemsDictionaryIfAvailable(items) { url in
                try fm.copyItem(at: url, to: resultPath.appendingPathComponent(url.lastPathComponent))
            }
        case .symlink(let itemsAndTheirResultPath):
            var failedItems: [URL: Error] = [:] // todo: use _returnFailedItemsDictionaryIfAvailable for this
            for (destURL, path) in itemsAndTheirResultPath {
                do {
                    try fm.createSymbolicLink(at: destURL, withDestinationURL: path)
                } catch {
                    failedItems[path] = error
                }
            }
            
            if !failedItems.isEmpty {
                var message: String = ""
                for (path, error) in failedItems {
                    message.append("\(path): \(error.localizedDescription)")
                }
                
                throw _Errors.otherError(description: message.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        case .setOwner(let url, let newOwner):
            try fm.setAttributes([.ownerAccountName: newOwner], ofItemAtPath: url.path)
        case .setGroup(let url, let newGroup):
            try fm.setAttributes([.groupOwnerAccountName: newGroup], ofItemAtPath: url.path)
        case .setPermissions(let url, let newOctalPermissions):
            try fm.setAttributes([.posixPermissions: newOctalPermissions], ofItemAtPath: url.path)
        case .writeData(let url, let data):
            try data.write(to: url)
        case .writeString(let url, let string):
            try string.write(to: url, atomically: true, encoding: .utf8)
        case .extractCatalog(let renditions, let resultPath):
            try fm.createDirectory(at: resultPath, withIntermediateDirectories: true)
            var failedItems: [String: String] = [:]
            for rend in renditions {
                let newURL = resultPath.appendingPathComponent(rend.renditionName)
                if let data = rend.itemData {
                    do {
                        try FSOperation.perform(.writeData(url: newURL, data: data), rootHelperConf: rootHelperConf)
                    } catch {
                        failedItems[rend.renditionName] = "Unable to write item data to file: \(error.localizedDescription)"
                    }
                }
            }
            
            if !failedItems.isEmpty {
                var message: String = ""
                for (item, error) in failedItems {
                    message.append("\(item): \(error)")
                }
                
                throw _Errors.otherError(description: message.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
    }
    
    /*
    public static func perform(_ operation: FSOperation, url: URL, rootHelperConf: RootHelperConfiguration?) throws {
        if let rootHelperConf = rootHelperConf, rootHelperConf.useRootHelper {
            rootHelperConf.action(operation, url)
            return
        }
        
        switch operation {
        case .removeItem:
            try fm.removeItem(at: url)
        case .createFile:
            // fopen being nil: failed to make file
            // mode a: create if the path doesn't exist
            guard let file = fopen((url as NSURL).fileSystemRepresentation, "a") else {
                throw _Errors.errnoError
            }
            
            fclose(file) // close when we're done
        case .createDirectory:
            try fm.createDirectory(at: url, withIntermediateDirectories: true)
        case .moveItem(let resultPath):
            try fm.moveItem(at: url, to: resultPath)
        case .copyItem(let resultPath):
            try fm.copyItem(at: url, to: resultPath)
        case .symlink(let destination):
            try fm.createSymbolicLink(at: destination, withDestinationURL: url)
        case .setGroup(let newGroup):
            try fm.setAttributes([.groupOwnerAccountName: newGroup], ofItemAtPath: url.path)
        case .setOwner(let newOwner):
            try fm.setAttributes([.ownerAccountName: newOwner], ofItemAtPath: url.path)
        case .setPermissions(let newOctalPermissions):
            try fm.setAttributes([.posixPermissions: newOctalPermissions], ofItemAtPath: url.path)
        case .writeData(let data):
            try data.write(to: url)
        case .extractCatalog(let rends):
            var failedItems: [String: String] = [:]
            for rend in rends {
                let newURL = url.appendingPathComponent(rend.renditionName)
                if let data = rend.itemData {
                    do {
                        try FSOperation.perform(.writeData(data: data), url: newURL, rootHelperConf: rootHelperConf)
                    } catch {
                        failedItems[rend.renditionName] = "Unable to write item data to file: \(error.localizedDescription)"
                    }
                }
                

            }
        }
    }
     */
    
    private enum _Errors: Error, LocalizedError {
        case errnoError
        case otherError(description: String)
        
        var errorDescription: String? {
            switch self {
            case .errnoError:
                return String(cString: strerror(errno))
            case .otherError(let description):
                return description
            }
        }
    }
}
