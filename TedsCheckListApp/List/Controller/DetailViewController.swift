//
//  DetailViewController.swift
//  TedsCheckListApp
//
//  Created by Ted McGuiggan on 8/30/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    var itemTitle: String?
    var itemBody: String?
    
    public var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 26)
        return label
    }()
    
    public var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10)
        titleLabel.centerX(inView: view)
        titleLabel.text = itemTitle
        
        view.addSubview(bodyLabel)
        bodyLabel.anchor(top: titleLabel.bottomAnchor, paddingTop: 20)
        bodyLabel.centerX(inView: view)
        bodyLabel.text = itemBody
        
    }
    

}
