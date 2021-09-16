//
//  ViewController.swift
//  TedsCheckListApp
//
//  Created by Ted McGuiggan on 8/25/21.
//

import UIKit
import CoreData

class CheckListViewController: UITableViewController, UISearchBarDelegate {

    private let searchController = UISearchController(searchResultsController: nil)
    lazy var presenter = Presenter(with: self)
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.loadItems()
        configureSearchController()
        configureTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    
    @objc func addButtonPressed() {
        presenter.addButtonPressed()
    }
    
    func configureTableView() {
        tableView.register(ItemCell.self, forCellReuseIdentifier: "CheckList Cell")
        tableView.rowHeight = 60
    }
    
    func configureSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder = "Search for an item"
        navigationItem.searchController = searchController
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckList Cell", for: indexPath) as! ItemCell
        cell.titleLabel.text = itemArray[indexPath.row].title
        cell.bodyLabel.text = itemArray[indexPath.row].body
        cell.statusLabel.text = itemArray[indexPath.row].status
        cell.dateLabel.text = itemArray[indexPath.row].date
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "DetailView") as DetailViewController
        controller.itemArray = itemArray
        controller.indexPath = indexPath
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {

//        presenter.deleteItems(indexPath: indexPath)
        context.delete(itemArray[indexPath.row])
        self.itemArray.remove(at: indexPath.row)
        
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        
        saveItems()
      }
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchBarButtonClicked(searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchBar(searchBar, textDidChange: searchText)
    }
}

extension CheckListViewController: PresenterView {
  
    func saveItems() {
        presenter.saveItems(items: itemArray)
        tableView.reloadData()
    }
    
    func presentItems(items: [Item]) {
        self.itemArray = items
        tableView.reloadData()
    }
}

extension CheckListViewController: DetailViewControllerDelegate {
    func updateTableView(items: [Item]) {
        itemArray = items
        navigationController?.popViewController(animated: true)
        presenter.saveItems(items: itemArray)
    }
    
    
}

