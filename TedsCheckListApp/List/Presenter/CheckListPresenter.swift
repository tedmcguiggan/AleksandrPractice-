//
//  Presenter.swift
//  TedsCheckListApp
//
//  Created by Ted McGuiggan on 9/13/21.


import Foundation
import CoreData

protocol PresenterView: AnyObject {
    func presentItems(items: [ItemViewModel])
    func presentDetailView(for item: ItemViewModel?)
}

class CheckListPresenter {
    
    weak var view: PresenterView?
    private var items = [ItemViewModel]()
    var context: NSManagedObjectContext!

    init(with view: PresenterView) {
        self.view = view
    }
    
    func viewDidLoad() {
        loadItems()
    }
    
    func showDetail(index: Int?) {
        var item: ItemViewModel?
        if let index = index {
            item = items[index]
        }
        
        view?.presentDetailView(for: item)
    }
    
    func addNewItem(item: ItemViewModel) {
        let _ = item.getItem(context: context)
        saveItems()
    }
    
    func updateItem(item: ItemViewModel) {
        let request = Item.fetchRequest()
        request.predicate = NSPredicate(format: "id CONTAINS[cd] %@", item.id)
        
        do {
            guard let item = try context.fetch(request).first else { return }
            
            item.title = item.title
            item.setValue(item.title, forKey: "title")
            item.setValue(item.body, forKey: "body")
            item.setValue(item.status, forKey: "status")
            item.setValue(item.date, forKey: "date")
            saveItems()
        } catch  {
            print("Error fetching data")
        }
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
            let itemArray = try context.fetch(request)
            
            let convertedArray = itemArray.map { ItemViewModel(id: $0.id!, title: $0.title!, body: $0.body!, status: $0.status!, date: $0.date!) }
            self.items = convertedArray
            print("MADE IT TO PRESENT ITEMS")
            view?.presentItems(items: convertedArray)
        } catch  {
            print("Error fetching data")
        }
        
        
    }
    
    func searchItems(text: String) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(request: request)
    }

    func deleteItems(item: ItemViewModel) {
        do {
        
            let request = Item.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", item.id)
            if let item = try context.fetch(request).first {
                context.delete(item)
                saveItems()
            }
            
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}

private extension ItemViewModel {
    func getItem(context: NSManagedObjectContext) -> Item {
        let convertedItem = Item(context: context)
        convertedItem.title = title
        convertedItem.body = body
        convertedItem.status = status
        convertedItem.date = date
        convertedItem.id = id
        return convertedItem
    }
}
