//
//  UpdateAttributePresenter.swift
//  RecipeApp
//
//  Created by Phu Nguyen on 2/23/20.
//  Copyright © 2020 The Vis. All rights reserved.
//

import Foundation

protocol UpdateAttributeViewProtocol: class {
    func didUpdate(_ name: String)
    func showEmptyWarning()
}

class UpdateAttributePresenter: BasePresenter {
    private weak var hostedView: UpdateAttributeViewProtocol?
    var name: String?
    init(_ attachedView: UpdateAttributeViewProtocol) {
        self.hostedView = attachedView
    }
    
    func didSave(_ newName: String) {
        guard !newName.isEmpty else {
            hostedView?.showEmptyWarning()
            return
        }
        name = newName
        hostedView?.didUpdate(newName)
    }
}
