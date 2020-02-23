//
//  ReceipTypesPresenter.swift
//  RecipeApp
//
//  Created by Phu Nguyen on 2/22/20.
//  Copyright © 2020 The Vis. All rights reserved.
//

import Foundation

protocol ReceipTypesViewProtocol: class {
    func reloadReceipTypeList()
    func showEmptyReceipType()
    func didChoose(receipType type: ReceipType)
}

class ReceipTypesPresenter: BasePresenter {
    
    private weak var hostedView: ReceipTypesViewProtocol?
    private let dataManager: ReceipDataManager
    
    private var receipTypes: [ReceipType] = []
    var type: ReceipTypesViewMode = .filters
    var showingFilter: Bool = false
    
    init(_ attachedView: ReceipTypesViewProtocol) {
        self.hostedView = attachedView
        dataManager = ReceipDataManager()
    }
    
    func viewDidLoad() {
        fetchReceipTypes()
    }
    
    private func fetchReceipTypes() {
        dataManager.fetchReceipTypes { [weak self] (types) in
            if types.isEmpty {
                self?.hostedView?.showEmptyReceipType()
            } else {
                self?.receipTypes = types
                self?.hostedView?.reloadReceipTypeList()
            }
        }
    }
    
    
    
    func numberOfReceipTypes() -> Int {
        return type == .filters ? receipTypes.count : receipTypes.count - 1
    }
    
        
    func getReceipTypeName(forIndex index: Int) -> String {
        let realIndex = type == .filters ? index : (index + 1)
        return receipTypes[realIndex].name
    }
    
    func didChooseFilter(atIndex index: Int) {
        let realIndex = type == .filters ? index : (index + 1)
        hostedView?.didChoose(receipType: receipTypes[realIndex])
    }
}
