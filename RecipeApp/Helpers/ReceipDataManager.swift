//
//  ReceipDataManager.swift
//  RecipeApp
//
//  Created by Phu Nguyen on 2/22/20.
//  Copyright © 2020 The Vis. All rights reserved.
//

import Foundation

class ReceipDataManager: NSObject {
    
    private let fileManager = ReceipFileManager.shared
    private var emptyType: [String: Any]?
    private var receipTypes =  [ReceipType("All")]

    private var currentElementName: String?
    
    private var receipTypeCompletion: (([ReceipType]) -> Void)?
    

    override init() {
        super.init()
    }
    
    func fetchReceipTypes(_ completion: @escaping (([ReceipType]) -> Void)) {
        guard let data = fileManager.fetchReceipTypesData() else {
            completion([])
            return
        }
        receipTypeCompletion = completion
        let xmlParser = XMLParser.init(data: data)
        xmlParser.delegate = self
        xmlParser.parse()
        
    }
    
    func fetchReceips(_ completion: @escaping (([Receip]) -> Void)) {
        guard let data = fileManager.fetchReceips() else {
            completion([])
            return
        }
        if let receips = try? JSONDecoder().decode([Receip].self, from: data) {
            completion(receips)
        } else {
            completion([])
        }
        
    }
    
    func saveReceips(_ receips: [Receip]) {
        let savingQueue = DispatchQueue(label: "com.receipApp.savingqueue")
        savingQueue.async { [weak self] in
            let data = try? JSONEncoder().encode(receips)
            self?.fileManager.save(data)
        }
    }
    
    deinit {
        print("ReceipDataManager already deinit")
    }
}

extension ReceipDataManager: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "receip_types" { // ignore this node
            currentElementName = nil
            return
        }
        if elementName == "type" {
            emptyType = [:]
            currentElementName = nil
        } else {
            currentElementName = elementName
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "type" && emptyType != nil {
            // should be init with that dic
            let type = ReceipType(emptyType!)
            receipTypes.append(type)
            emptyType = nil //
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if let element = currentElementName,
            let dict = emptyType, dict[element] == nil {
            emptyType?[element] = string
            currentElementName = nil
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        receipTypeCompletion?(receipTypes)
        emptyType = nil
        currentElementName = nil
    }
    
}
