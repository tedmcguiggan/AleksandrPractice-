//
//  ViewController.swift
//  TedsCheckListApp
//
//  Created by Ted McGuiggan on 8/25/21.
//

import UIKit
import CoreData

class CheckListViewController: UITableViewController, ItemCellDelegate, UISearchBarDelegate {
   
    
    func toggleCheckMark() {
        print("made it here")
    }
    
    private let searchController = UISearchController(searchResultsController: nil)

    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        configureSearchController()
        configureTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
    }
    
    @objc func addButtonPressed() {
      
        let newItem = Item(context: context)
        var title = UITextField()
        var body = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            newItem.title = title.text
            newItem.body = body.text
            newItem.isDone = false
            self.itemArray.append(newItem)
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
        
        present(alert, animated: true, completion: nil)
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
    
    
    func saveItems() {
        do {
            try context.save()
        } catch  {
            print("Error saving context")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        } catch  {
            print("Error fetching data")
        }
        
        tableView.reloadData()
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckList Cell", for: indexPath) as! ItemCell
        cell.titleLabel.text = itemArray[indexPath.row].title
        cell.bodyLabel.text = itemArray[indexPath.row].body
        cell.delegate = self
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DetailViewController()
        controller.itemTitle = itemArray[indexPath.row].title
        controller.itemBody = itemArray[indexPath.row].body
        navigationController?.pushViewController(controller, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        print("Deleted")

        context.delete(itemArray[indexPath.row])
        self.itemArray.remove(at: indexPath.row)
        
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        
        saveItems()
      }
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(request: request)
                
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }

}

