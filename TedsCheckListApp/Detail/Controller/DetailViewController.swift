//
//  DetailViewController.swift
//  TedsCheckListApp
//
//  Created by Ted McGuiggan on 8/30/21.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func updateTableView(items: [Item])
}


class DetailViewController: UIViewController, PresenterView {
    func saveItems() {
        presenter.saveItems(items: itemArray)
    }
    
    func presentItems(items: [Item]) {
        print("123")
    }
    
    
    let status = ["To-Do","In Progress","Done"]
    weak var delegate: DetailViewControllerDelegate?
    
    public var itemArray = [Item]()
    var indexPath = IndexPath()
    lazy var presenter = Presenter(with: self)
    var statusSelected = "To-Do"


    @IBOutlet weak var itemTitle: UITextField!
    
    @IBOutlet weak var itemBody: UITextField!
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBOutlet weak var statusPicker: UIPickerView!
    
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        statusPicker.dataSource = self
        statusPicker.delegate = self
        
        
        itemTitle.text = itemArray[indexPath.row].title
        itemBody.text = itemArray[indexPath.row].body

    
    }
    

    
    @IBAction func saveChanges(_ sender: Any) {
        let dateFormatter = DateFormatter()
        itemArray[indexPath.row].title = itemTitle.text
        itemArray[indexPath.row].body = itemBody.text
        itemArray[indexPath.row].status = statusSelected
        itemArray[indexPath.row].date = dateFormatter.string(from: datePicker.date)
        
        self.delegate?.updateTableView(items: self.itemArray)
    }
    
}


extension DetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return status.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return status[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        statusSelected = status[row]
    }
    
}
