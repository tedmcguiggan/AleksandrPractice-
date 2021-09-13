//
//  ItemCell.swift
//  TedsCheckListApp
//
//  Created by Ted McGuiggan on 8/29/21.
//

import Foundation

import UIKit


protocol ItemCellDelegate: AnyObject {
    func toggleCheckMark()
}

class ItemCell: UITableViewCell {
    
    var isChecked = false
    weak var delegate: ItemCellDelegate?
        
    
    
    public var checkboxImage: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "square")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(toggleCheckMark), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()
    
    public var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    public var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    @objc func toggleCheckMark() {
        delegate?.toggleCheckMark()
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 4

//        addSubview(checkboxImage)
//        checkboxImage.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
