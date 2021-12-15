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
    
    lazy var presenter = CheckListPresenter(with: self)
    var items = [ItemViewModel]()
    var selectedItem: ItemViewModel?
    let dateFormatter = DateFormatter()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.context = context
        searchBar.delegate = self
        tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "CheckList Cell")
        tableView.rowHeight = 60
        presenter.viewDidLoad()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        presenter.showDetail()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckList Cell", for: indexPath) as! EventCell
        dateFormatter.dateFormat = "MM/dd/YY"
        let date = dateFormatter.string(from: items[indexPath.row].date!)
        cell.titleLabel.text = items[indexPath.row].title
        cell.bodyLabel.text = items[indexPath.row].body
        cell.statusLabel.text = items[indexPath.row].status
        cell.dateLabel.text = date
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = items[indexPath.row]
        presenter.showDetail()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            if let selectedItem = selectedItem {
                destination.item = selectedItem
            }
            destination.delegate = self
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchItems(text: searchBar.text!)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            presenter.viewDidLoad()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

extension CheckListViewController: PresenterView {
    
    func presentItems(items: [ItemViewModel]) {
        self.items = items
        tableView.reloadData()
    }
    
    func presentDetailView() {
        performSegue(withIdentifier: "showDetail", sender: self)
    }

}


extension CheckListViewController: DetailViewControllerDelegate {
    
    func addNewItem(item: ItemViewModel) {
        presenter.addNewItem(item: item)
        selectedItem = nil
    }
    
    func updateItem(item: ItemViewModel) {
        presenter.updateItem(item: item)
        selectedItem = nil
    }
    
    func deleteItem(item: ItemViewModel) {
        presenter.deleteItems(item: item)
        selectedItem = nil
    }
}

