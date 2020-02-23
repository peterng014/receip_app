//
//  ReceipDetailPresenter.swift
//  RecipeApp
//
//  Created by Phu Nguyen on 2/22/20.
//  Copyright © 2020 The Vis. All rights reserved.
//

import Foundation

protocol ReceipDetailViewProtocol: class {
    func bindReceipInfos()
    func showReceipTypePickerView()
    func updateInfo(with name: String, index indexPath: IndexPath)
    func reloadTableView(at index: IndexPath)
    func didAddMoreItems(at indexs: [IndexPath])
    func showAlert(_ message: String)
    func didAddReceip()
}

enum DetailViewMode {
    case view
    case update
    case new
    
    var title: String {
        switch self {
        case .new, .update:
            return "Save"
        case .view:
            return "Update"
        }
    }
}


class ReceipDetailPresenter: BasePresenter {
    
    func viewDidLoad() {
        hostedView?.bindReceipInfos()
    }
    
    enum ReceipSection: Int, CaseIterable  {
        case receipType = 0
        case ingredients
        case steps
        
        var title: String {
            switch self {
            case  .receipType:
                return "Receip Type"
            case .ingredients:
                return "Ingredients"
            case .steps:
                return "How to cooks"
            }
        }
    }
    
    private weak var hostedView: ReceipDetailViewProtocol?
    var receip: Receip? {
        didSet {
            mode = receip != nil ? .view : .new
            if receip == nil {
                newReceip = Receip("")
            }
        }
    }
    var mode: DetailViewMode = .new
    var newReceip: Receip? = nil
    init(_ attachedView: ReceipDetailViewProtocol) {
        self.hostedView = attachedView
    }
    
    
    
    func numberOfSections() -> Int {
        return ReceipSection.allCases.count
    }
    
    func numberRows(forSection section: Int) -> Int {
        if let receipt = receip ?? newReceip {
            return section == ReceipSection.ingredients.rawValue ?
                receipt.ingredients.count :
                (ReceipSection.steps.rawValue == section ?
                    receipt.steps.count : 1)
        }
        
        //
        return 0
    }
    
    func title(for indexPath: IndexPath) -> String {
        guard let receip = receip ?? newReceip else { return "" }
        switch indexPath.section {
        case ReceipSection.receipType.rawValue:
            return receip.type.name
        case ReceipSection.ingredients.rawValue:
            return receip.ingredients[indexPath.row].description
        case ReceipSection.steps.rawValue:
            return "Step \(indexPath.row + 1): \(receip.steps[indexPath.row])"
        default:
            return ""
        }
    }
    
    func isTheLast(for indexPath: IndexPath) -> Bool {
        guard let receip = receip ?? newReceip else { return false }
        let number = indexPath.section == ReceipSection.ingredients.rawValue ?
            receip.ingredients.count: receip.steps.count
        return (number - 1) == indexPath.row
    }
    
    func titleForHeader(inSection section: Int) -> String {
        return ReceipSection.allCases[section].title
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard mode == .new || mode == .update else { return }
        guard let receip = receip ?? newReceip else { return }
        var name = ""
        if indexPath.section == ReceipSection.receipType.rawValue {
            hostedView?.showReceipTypePickerView()
            return
        } else if indexPath.section == ReceipSection.ingredients.rawValue {
            let ingredient = receip.ingredients[indexPath.row]
            name = ingredient.name
        } else if indexPath.section == ReceipSection.steps.rawValue {
            name = receip.steps[indexPath.row]
        }
        hostedView?.updateInfo(with: name, index: indexPath)
        selectedIndex = indexPath
    }
    
    private var selectedSection: Int?
    func willAddNewAttribute(for section: Int) {
        selectedSection = section
    }
    
    func didAddNewAttribute(_ name: String) {
        guard let section = selectedSection else { return }
        selectedSection = nil
        guard !name.isEmpty else { return }
        var number = -1
        if section == ReceipSection.ingredients.rawValue {
            newReceip?.ingredients.append(Ingredient(quantity: "1", name: name, type: ""))
            number = newReceip?.ingredients.count ?? -1
        }
        else if section == ReceipSection.steps.rawValue {
            newReceip?.steps.append(name)
            number = newReceip?.steps.count ?? -1
        }
        let row = number - 1
        if (row) >= 0 {
            hostedView?.didAddMoreItems(at: [IndexPath(row: row, section: section)])
        }
    }
    
    private var selectedIndex: IndexPath?
    func didUpdateAttribute(_ name: String) {
        guard let index = selectedIndex else { return }
        selectedIndex = nil
        guard !name.isEmpty else { return }
        if index.section == ReceipSection.ingredients.rawValue {
            receip?.ingredients[index.row].name = name
        }
        else if index.section == ReceipSection.steps.rawValue {
            receip?.steps[index.row] = name
        }
        hostedView?.reloadTableView(at: index)
    }
    
    func didUpdateReceipType(_ newType: ReceipType) {
        if receip != nil {
            receip?.type = newType
        } else {
            newReceip?.type = newType
        }
        hostedView?.reloadTableView(at: IndexPath(row: 0, section: 0))
    }
    
    func willAddReceip(_ name: String) {
        if name.isEmpty || name == "Receip Name" {
            hostedView?.showAlert("Receip Name cannot be empty")
            return
        }
        guard let newReceip = newReceip else { return }
        newReceip.name = name
        if newReceip.type.id < 0 {
            hostedView?.showAlert("Please choose a receip type")
        } else {
            hostedView?.didAddReceip()
        }
    }

}
