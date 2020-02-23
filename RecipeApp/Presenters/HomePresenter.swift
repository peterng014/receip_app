//
//  HomePresenter.swift
//  RecipeApp
//
//  Created by Phu Nguyen on 2/22/20.
//  Copyright © 2020 The Vis. All rights reserved.
//

import Foundation

protocol HomeViewProtocol: class {
    func reloadReceipList(_ update: Bool)
    func showEmptyReceipList()
}

class HomePresenter: BasePresenter {
    
    private weak var hostedView: HomeViewProtocol?
    private let dataManager: ReceipDataManager
    
    private var receipTypes: [ReceipType] = []
    private var receipList: [Receip] = []
    private var filteredReceips = [Receip]()
    
    var showingFilter: Bool = false
    
    init(_ attachedView: HomeViewProtocol) {
        self.hostedView = attachedView
        dataManager = ReceipDataManager()
    }
    
    func viewDidLoad() {
        fetchReceips()
    }
    
    private func fetchReceips() {
        dataManager.fetchReceips { [weak self] (receips) in
            if receips.isEmpty {
                self?.hostedView?.showEmptyReceipList()
            } else {
                self?.receipList = receips
                self?.filteredReceips = receips
                self?.hostedView?.reloadReceipList(false)
            }
        }
    }
        
    func numberOfReceips() -> Int {
        return filteredReceips.count
    }
    
    func getReceip(forIndex index: Int) -> Receip {
        return filteredReceips[index]
    }
        
    func didChooseFilter(receipType type: ReceipType) {
        if type.id == -1 {
            filteredReceips = receipList
        } else {
            filteredReceips = receipList.filter { $0.type.id == type.id }
        }
        self.hostedView?.reloadReceipList(true)
    }
    
    func didAdd(newReceip receip: Receip) {
        receipList.append(receip)
        filteredReceips.append(receip)
        hostedView?.reloadReceipList(true)
        dataManager.saveReceips(receipList)
    }
    
    
}
