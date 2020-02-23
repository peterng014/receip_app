//
//  ReceipDetailViewController.swift
//  RecipeApp
//
//  Created by Phu Nguyen on 2/22/20.
//  Copyright © 2020 The Vis. All rights reserved.
//

import UIKit

protocol ReceipDetailViewControllerDelegate: class {
    func didAdd(newReceip receip: Receip?)
}


class ReceipDetailViewController: UIViewController, UINavigationControllerDelegate {
    private let cellIdentifier = "receipDetailIdentifier"
    lazy var presenter = {
        return ReceipDetailPresenter(self)
    }()
    
    lazy private var pickerView: ReceipTypesViewController = {
        let view = ReceipTypesViewController()
        view.delegate = self
        view.presenter.type = .options
        return view
    }()
    
    @IBOutlet weak var receipNameTextView: UITextView!
    @IBOutlet weak var receipImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    @IBOutlet weak var headerContainerView: UIView!
    
    weak var delegate: ReceipDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    @IBAction func didTapRightBarButton(_ sender: UIBarButtonItem) {
        if presenter.mode == .new {
            presenter.willAddReceip(receipNameTextView.text)
        } else {
            presenter.mode = .update
        }
        receipNameTextView.isEditable = presenter.mode != .view
    }
    
    @IBAction func updateReceipImage(_ sender: UITapGestureRecognizer) {
        let imgPicker = UIImagePickerController()
        imgPicker.sourceType = .photoLibrary
        imgPicker.delegate = self
        present(imgPicker, animated: true, completion: nil)
    }
    
    @objc private func addNewAttribute(_ button: UIButton) {
        performSegue(withIdentifier: Constants.SegueName.addAttributesSegueIdentifier,
                     sender: nil)
        // button tag keeps the selected section
        presenter.willAddNewAttribute(for: button.tag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueName.addAttributesSegueIdentifier,
        let vc = segue.destination as? UpdateAttributeViewController {
            vc.presenter.name =  sender as? String ?? ""
            vc.delegate = self
        }
    }
}

extension ReceipDetailViewController: UpdateAttributeViewControllerDelegate {
    func didUpdateAttribute(with name: String) {
        presenter.mode == .new ? presenter.didAddNewAttribute(name) :
        presenter.didUpdateAttribute(name)
    }
}

extension ReceipDetailViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage {
            receipImageView.image = img
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private methods
extension ReceipDetailViewController {
    
    func showPickerTypesView() {
        addChild(pickerView)
        view.addSubview(pickerView.view)
    }
    
    func header(forSection section: Int) -> UIView {
        let header  = UIView()
        let label   = UILabel()
        let button  = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        label.text = presenter.titleForHeader(inSection: section)
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        header.addSubview(label)
        
        label.leadingAnchor
            .constraint(equalTo: header.leadingAnchor,
                        constant: Constants.Margins.horizonal )
            .isActive = true
        label.centerYAnchor
            .constraint(equalTo: header.centerYAnchor)
            .isActive = true
        if section != 0 {
            button.addTarget(self, action: #selector(addNewAttribute(_:)),
                             for: .touchUpInside)
            button.tag = section
            header.addSubview(button)
            button.trailingAnchor
                .constraint(equalTo: header.trailingAnchor,
                            constant: -Constants.Margins.horizonal )
                .isActive = true
            button.centerYAnchor
                .constraint(equalTo: header.centerYAnchor)
                .isActive = true
        }
        return header
    }
}

extension ReceipDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
        return presenter.numberRows(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = presenter.title(for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)
        -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)
        -> String? {
        return presenter.titleForHeader(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int)
        -> UIView? {
        return presenter.mode == .new ? header(forSection: section) : nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
    }
}


extension ReceipDetailViewController: ReceipDetailViewProtocol {
    func bindReceipInfos() {
        rightBarButton.title = presenter.mode.title
        receipNameTextView.isEditable = presenter.mode != .view
        guard let receip = presenter.receip else {
            title = "Create new receip"
            return
        }
        title = receip.name
        receipNameTextView.text = receip.name
        if !receip.imageName.isEmpty {
            receipImageView.image = UIImage(named: receip.imageName)
        }
        tableView.reloadData()
    }
    
    func showReceipTypePickerView() {
        showPickerTypesView()
    }
    
    func updateInfo(with name: String, index indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.SegueName.addAttributesSegueIdentifier,
                     sender: name)
    }
    
    func reloadTableView(at index: IndexPath) {
        tableView.reloadRows(at: [index], with: .fade)
    }
    
    func didAddMoreItems(at indexs: [IndexPath]) {
        tableView.insertRows(at: indexs, with: .fade)
    }
    
    func didAddReceip() {
        navigationController?.popViewController(animated: true)
        delegate?.didAdd(newReceip: presenter.newReceip)
    }
    
    func showAlert(_ message: String) {
        UIAlertController.show(message, fromController: self)
    }
}


extension ReceipDetailViewController: ReceipTypesViewControllerDelegate {
    func receipTypes(_ pickerView: ReceipTypesViewController, didChoose
        type: ReceipType) {
        pickerView.removeFromParent()
        pickerView.view.removeFromSuperview()
        presenter.didUpdateReceipType(type)
    }
}
