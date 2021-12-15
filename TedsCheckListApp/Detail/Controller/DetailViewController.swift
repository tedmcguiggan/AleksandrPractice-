//
//  DetailViewController.swift
//  TedsCheckListApp
//
//  Created by Ted McGuiggan on 8/30/21.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func addNewItem(item: ItemViewModel)
    func updateItem(item: ItemViewModel)
    func deleteItem(item: ItemViewModel)
}


class DetailViewController: UIViewController {

    let status = ["To-Do","In Progress","Done"]
    weak var delegate: DetailViewControllerDelegate?
    var item: ItemViewModel? = nil
    var statusSelected: Status = .toDO
    
    
    @IBOutlet weak var itemTitle: UITextField!
    
    @IBOutlet weak var itemBody: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var statusPicker: UIPickerView!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        statusPicker.dataSource = self
        statusPicker.delegate = self
        setDefaultValue()
        
        if let item = item {
            itemTitle.text = item.title
            itemBody.text = item.body
        } else {
            deleteBtn.isHidden = true
        }
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        if let item = item {
            let updatedItem = ItemViewModel(title: itemTitle.text, body: itemBody.text, status: statusSelected.currentStatus, date: datePicker.date, id: item.id)
            self.item = nil
            delegate?.updateItem(item: updatedItem)
        } else {
            let uuid = UUID().uuidString
            let newItem = ItemViewModel(title: itemTitle.text, body: itemBody.text, status: statusSelected.currentStatus, date: datePicker.date, id: uuid)
            self.delegate?.addNewItem(item: newItem)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteItem(_ sender: Any) {
        if let item = item {
            delegate?.deleteItem(item: item)
            navigationController?.popViewController(animated: true)
        }
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
    
    func setDefaultValue(){
        if let item = item {
            if let indexPosition = status.firstIndex(of: (item.status)!){
                statusPicker.selectRow(indexPosition, inComponent: 0, animated: false)
            }
            datePicker.date = item.date!
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch status[row] {
        case "To-Do":
            statusSelected = .toDO
        case "In Progress":
            statusSelected = .inProgress
        case "Done":
            statusSelected = .done
        default:
            break
        }
    }
}
