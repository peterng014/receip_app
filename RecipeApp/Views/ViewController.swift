//
//  ViewController.swift
//  RecipeApp
//
//  Created by Phu Nguyen on 2/22/20.
//  Copyright © 2020 The Vis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var emptyListView: UIView!
    @IBOutlet var tableView: UITableView!
    
    lazy private var presenter: HomePresenter = {
       return HomePresenter(self)
    }()
    lazy private var pickerView: ReceipTypesViewController = {
        let view = ReceipTypesViewController()
        view.delegate = self
        return view
    }()
    
    private let cellIdentifier = "receipCellIdentifier"
    private var selectedReceip: Receip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    @IBAction func filterReceips(_ sender: UIBarButtonItem) {
        if presenter.showingFilter {
            pickerView.removeFromParent()
            pickerView.view.removeFromSuperview()
        } else {
            addChild(pickerView)
            view.addSubview(pickerView.view)
        }
        presenter.showingFilter.toggle()
    }
    
    
}

extension ViewController: ReceipTypesViewControllerDelegate {
    func receipTypes(_ pickerView: ReceipTypesViewController, didChoose type: ReceipType) {
        pickerView.removeFromParent()
        pickerView.view.removeFromSuperview()
        presenter.didChooseFilter(receipType: type)
        presenter.showingFilter.toggle()
    }
}


extension ViewController: HomeViewProtocol {
    func showEmptyReceipList() {
        view = emptyListView
    }
    
    func reloadReceipList(_ update: Bool) {
        if update {
            tableView.reloadData()
            return
        }
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
            .isActive = true
        tableView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)
            .isActive = true
        tableView.bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
            .isActive = true
        tableView.topAnchor
            .constraint(equalTo: view.topAnchor)
            .isActive = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("yahhh I got it")
        print(segue.identifier ?? "")
        if segue.identifier == Constants.SegueName.showDetailSegueIdentifier {
            if let destController = segue.destination as? ReceipDetailViewController {
                destController.presenter.receip = selectedReceip
                destController.delegate = self
            }
        }
    }
}

extension ViewController: ReceipDetailViewControllerDelegate {
    func didAdd(newReceip receip: Receip?) {
        if let receip = receip {
            presenter.didAdd(newReceip: receip)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfReceips()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.numberOfLines = 0
        let receip = presenter.getReceip(forIndex: indexPath.row)
        cell.textLabel?.text = receip.name
        cell.detailTextLabel?.text = receip.type.name
        cell.imageView?.image = receip.imageName.isEmpty ?
            UIImage(named: "placeholder") : UIImage(named: receip.imageName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedReceip = presenter.getReceip(forIndex: indexPath.row)
        performSegue(withIdentifier: Constants.SegueName.showDetailSegueIdentifier, sender: nil)
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedReceip = nil
    }
    
}
