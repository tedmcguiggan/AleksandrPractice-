//
//  Presenter.swift
//  TedsCheckListApp
//
//  Created by Ted McGuiggan on 9/13/21.


import Foundation
import CoreData

protocol PresenterView: AnyObject {
    func presentItems(items: [ItemViewModel])
    func presentDetailView()
}

class CheckListPresenter {
    
    weak var view: PresenterView?
    private var itemArray = [Item]()
    var context: NSManagedObjectContext!

    init(with view: PresenterView) {
        self.view = view
    }
    
    func viewDidLoad() {
        loadItems()
    }
    
    func showDetail() {
        view?.presentDetailView()
    }
    
    func addNewItem(item: ItemViewModel) {
        let convertedItem = convertToItem(item: item)
        itemArray.append(convertedItem)
        saveItems()
    }
    
    func convertToItem(item: ItemViewModel) -> Item {
        let convertedItem = Item(context: context)
        convertedItem.title = item.title
        convertedItem.body = item.body
        convertedItem.status = item.status
        convertedItem.date = item.date
        convertedItem.id = item.id
        return convertedItem
    }
    
    func updateItem(item: ItemViewModel) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        var foundItem = [Item]()
        request.predicate = NSPredicate(format: "id CONTAINS[cd] %@", item.id!)
        do {
            foundItem = try context.fetch(request)
        } catch  {
            print("Error fetching data")
        }
        let uneditedItem = foundItem[0]
        uneditedItem.setValue(item.title, forKey: "title")
        uneditedItem.setValue(item.body, forKey: "body")
        uneditedItem.setValue(item.status, forKey: "status")
        uneditedItem.setValue(item.date, forKey: "date")
        saveItems()
    }
    
    private func saveItems() {
        do {
            try context.save()
        } catch  {
            print("Error saving context")
        }
        loadItems()
    }
    
    private func loadItems(request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            print("MADE IT TO LOAD ITEMS")
            itemArray = try context.fetch(request)
        } catch  {
            print("Error fetching data")
        }
        
        var convertedArray = [ItemViewModel]()
        for x in itemArray {
            let item = ItemViewModel(title: x.title, body: x.body, status: x.status, date: x.date, id: x.id)
            convertedArray.append(item)
        }
        print("MADE IT TO PRESENT ITEMS")
        view?.presentItems(items: convertedArray)
    }
    
    func searchItems(text: String) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(request: request)
    }

    func deleteItems(item: ItemViewModel) {
        var convertedItem = Item(context: context)
        convertedItem = convertToItem(item: item)
        context.delete(convertedItem)
        saveItems()
    }
}
