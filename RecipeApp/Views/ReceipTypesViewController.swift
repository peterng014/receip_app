//
//  ReceipTypesViewController.swift
//  RecipeApp
//
//  Created by Phu Nguyen on 2/22/20.
//  Copyright © 2020 The Vis. All rights reserved.
//

import UIKit

protocol ReceipTypesViewControllerDelegate: class {
    func receipTypes(_ pickerView: ReceipTypesViewController, didChoose type: ReceipType)
}

enum ReceipTypesViewMode {
    case filters
    case options
}

class ReceipTypesViewController: UIViewController {
    private var pickerView: UIPickerView!
    private let pickerViewHeight: CGFloat = 216.0
    
    lazy var presenter: ReceipTypesPresenter = {
        return ReceipTypesPresenter(self)
    }()
    weak var delegate: ReceipTypesViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }
    
}

extension ReceipTypesViewController: ReceipTypesViewProtocol {
    func reloadReceipTypeList() {
        pickerView.reloadAllComponents()
    }
    
    func showEmptyReceipType() {
        print("Something was wrong, cannot load receip types")
    }
    
    func didChoose(receipType type: ReceipType) {
        delegate?.receipTypes(self, didChoose: type)
    }
}

extension ReceipTypesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int)
        -> Int {
        return presenter.numberOfReceipTypes()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return presenter.getReceipTypeName(forIndex: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        presenter.didChooseFilter(atIndex: row)
    }
    
}


extension ReceipTypesViewController {
    func setup() {
        view.backgroundColor    = .clear
        pickerView              = UIPickerView()
        pickerView.dataSource   = self
        pickerView.delegate     = self
                
        pickerView.backgroundColor                           = .lightGray
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(pickerView)
        pickerView.leadingAnchor
            .constraint(equalTo: self.view.leadingAnchor)
            .isActive = true
        pickerView.trailingAnchor
            .constraint(equalTo: self.view.trailingAnchor)
            .isActive = true
        pickerView.bottomAnchor
            .constraint(equalTo: self.view.bottomAnchor)
            .isActive = true
        pickerView.heightAnchor
            .constraint(equalToConstant: pickerViewHeight)
            .isActive = true
    }
}

