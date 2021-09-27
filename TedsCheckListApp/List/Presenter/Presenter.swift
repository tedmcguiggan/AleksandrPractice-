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
    
    public func saveItems(items: [Item]) {
        self.itemArray = items
        do {
            try context.save()
        } catch  {
            print("Error saving context")
        }
        view?.presentItems(items: itemArray)
    }
    
    public func loadItems(request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        } catch  {
            print("Error fetching data")
        }
        view?.presentItems(items: itemArray)
    }
    
    public func searchBarButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(request: request)
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    func deleteItems(item: Item) {
        context.delete(item)
        loadItems()
    }
}
