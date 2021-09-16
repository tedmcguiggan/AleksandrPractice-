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
    
    public var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .green
        return label
    }()
    
    public var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 4

        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        addSubview(statusLabel)
        statusLabel.centerY(inView: self)
        statusLabel.anchor(right: safeAreaLayoutGuide.rightAnchor, paddingRight: 50)
        
//        addSubview(dateLabel)
//        dateLabel.centerY(inView: self, leftAnchor: statusLabel.rightAnchor, paddingLeft: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
