//
//  ReceipFileManager.swift
//  RecipeApp
//
//  Created by Phu Nguyen on 2/22/20.
//  Copyright © 2020 The Vis. All rights reserved.
//

import Foundation


class ReceipFileManager {
    static let shared = ReceipFileManager()
    
    private let fileManager: FileManager
    private var receipFileExist: Bool = false
    
    private var documentPath: String {
        get {
            return NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                       .userDomainMask, true).first!
        }
    }
    private var receipDocumentPath: String {
        get {
            return documentPath + "/" + Constants.File.receipsName + "." + Constants.File.receipsExtension;
        }
    }
    init() {
        fileManager = FileManager.default
        receipFileExist = fileManager.fileExists(atPath: receipDocumentPath)
        print("receipFileExist \(receipFileExist)")
    }
    
    func fetchReceips() -> Data? {
        var data: Data?
        if receipFileExist {
            data = fileManager.contents(atPath: receipDocumentPath)
        } else {
            data = try? read(file: Constants.File.receipsName, withExtension: Constants.File.receipsExtension)
            try? copyReceipsFile()
        }
        return data
    }
    
    func copyReceipsFile() throws {
        if let path = Bundle.main.path(forResource: Constants.File.receipsName, ofType: Constants.File.receipsExtension) {
            do {
                try fileManager.copyItem(atPath: path, toPath: receipDocumentPath)
            } catch {
                print("copy file error")
                throw FileManagerError.copyFileError
            }
        }
    }
    
    func fetchReceipTypesData() -> Data? {
        if let data = try? read(file: Constants.File.receipTypeName, withExtension: Constants.File.receipTypeExtension) {
            return data
        }
        return nil
    }
    
    func save(_ data: Data?) {
        guard let data = data else { return }
        let fileUrl = URL(fileURLWithPath: receipDocumentPath)
        do {
            try data.write(to: fileUrl, options: .atomic)
        } catch {
            print("Write file error \(error)")
        }
    }
    
    
    private func read(file name: String, withExtension fileExtension: String) throws -> Data? {
        do {
            guard let url = getAppResourceUrl(file: name, fileExtension: fileExtension) else {
                return nil
            }
            return try Data(contentsOf: url)
        } catch {
            print("Read data file error \(error)")
            throw FileManagerError.readFileError
        }
    }
    
    private func getAppResourceUrl(file name: String, fileExtension: String) -> URL? {
        if let path = Bundle.main.path(forResource: name, ofType: fileExtension) {
            return URL(fileURLWithPath: path)
        }
        return nil
        
    }
}
