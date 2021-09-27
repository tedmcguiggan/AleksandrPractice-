//
//  ViewController.swift
//  TedsCheckListApp
//
//  Created by Ted McGuiggan on 8/25/21.
//

import UIKit
import CoreData

class CheckListViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    lazy var presenter = Presenter(with: self)
    var items = [Item]()
    var indexPath = IndexPath()
    let dateFormatter = DateFormatter()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        presenter.loadItems()
        tableView.register(ItemCell.self, forCellReuseIdentifier: "CheckList Cell")
        tableView.rowHeight = 60
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let date = Date()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let newItem = Item(context: context)
        var title = UITextField()
        var body = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            newItem.title = title.text
            newItem.body = body.text
            newItem.status = "To-Do"
     //       newItem.date = date
            self.items.append(newItem)
            self.saveItems()
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Item Name"
            title = alertTextField
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Item Description"
            body = alertTextField
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckList Cell", for: indexPath) as! ItemCell
        cell.titleLabel.text = items[indexPath.row].title
        cell.bodyLabel.text = items[indexPath.row].body
        cell.statusLabel.text = items[indexPath.row].status
  //      cell.dateLabel.text = dateFormatter.string(from: items[indexPath.row].date!)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexPath = indexPath
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            destination.items = items
            destination.indexPath = indexPath
            destination.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        presenter.deleteItems(item: items[indexPath.row])
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
        presenter.saveItems(items: items)
        tableView.reloadData()
    }
    
    func presentItems(items: [Item]) {
        self.items = items
        tableView.reloadData()
    }
}

extension CheckListViewController: DetailViewControllerDelegate {
    func updateTableView(items: [Item]) {
        self.items = items
        navigationController?.popViewController(animated: true)
        presenter.saveItems(items: items)
    }
}

