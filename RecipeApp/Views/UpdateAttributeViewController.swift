//
//  UpdateAttributeViewController.swift
//  RecipeApp
//
//  Created by Phu Nguyen on 2/22/20.
//  Copyright © 2020 The Vis. All rights reserved.
//

import UIKit

protocol UpdateAttributeViewControllerDelegate: class {
    func didUpdateAttribute(with name: String)
}
class UpdateAttributeViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    weak var delegate: UpdateAttributeViewControllerDelegate?
    
    lazy var presenter: UpdateAttributePresenter = {
        return UpdateAttributePresenter(self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = presenter.name
    }
    
    @IBAction func saveName(_ sender: UIBarButtonItem) {
        presenter.didSave(nameTextField.text ?? "")
    }
}

extension UpdateAttributeViewController: UpdateAttributeViewProtocol {
    func didUpdate(_ name: String) {
        navigationController?.popViewController(animated: true)
        delegate?.didUpdateAttribute(with: name)
    }
    
    func showEmptyWarning() {
        UIAlertController.show("The name cannot be empty", fromController: self)
    }
}
