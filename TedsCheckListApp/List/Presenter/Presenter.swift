//
//  Presenter.swift
//  TedsCheckListApp
//
//  Created by Ted McGuiggan on 9/13/21.


import Foundation
import UIKit
import CoreData

protocol PresenterView: AnyObject {
    func saveItems()
    func presentItems(items: [Item])
 
}

typealias delegateView = PresenterView & UIViewController

class Presenter {
    
    weak var view: delegateView?
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    init(with view: delegateView) {
        self.view = view
    }
    
    @objc func addButtonPressed() {
        let newItem = Item(context: context)
        var title = UITextField()
        var body = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            newItem.title = title.text
            newItem.body = body.text
            newItem.status = "To-Do"
            newItem.date = "2021-03-07"
            self.itemArray.append(newItem)
            self.saveItems(items: self.itemArray)
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
        
        view?.present(alert, animated: true, completion: nil)
    }
    
    func saveItems(items: [Item]) {
        self.itemArray = items
        do {
            try context.save()
        } catch  {
            print("Error saving context")
        }
        view?.presentItems(items: itemArray)
    }
    
    func loadItems(request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        } catch  {
            print("Error fetching data")
        }
        view?.presentItems(items: itemArray)
    }
    
    func searchBarButtonClicked(_ searchBar: UISearchBar) {
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
    
//    func deleteItems(indexPath: IndexPath) {
//        context.delete(itemArray[indexPath.row])
//        self.itemArray.remove(at: indexPath.row)
//        
//        view?.tableView.deleteRows(at: [indexPath], with: .automatic)
//        
//        saveItems(items: itemArray)
//    }
    
}
