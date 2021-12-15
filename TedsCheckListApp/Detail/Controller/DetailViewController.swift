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
        if var item = item {
            item.title = itemTitle.text!
            item.body = itemBody.text!
            item.status = statusSelected.rawValue
            item.date = datePicker.date
            delegate?.updateItem(item: item)
        } else {
            let newItem = ItemViewModel(id: UUID().uuidString, title: itemTitle.text ?? "", body: itemBody.text ?? "", status: statusSelected.rawValue, date: datePicker.date)
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
        return Status.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Status.allCases[row].description
    }
    
    func setDefaultValue() {
        guard let item = item else { return }
        
        if let status = Status(rawValue: item.status), let index = Status.allCases.firstIndex(of: status) {
            statusPicker.selectRow(index, inComponent: 0, animated: false)
        }
        
        datePicker.date = item.date
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        statusSelected = Status.allCases[row]
    }
}
