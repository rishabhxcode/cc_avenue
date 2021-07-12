//
//  CCResultViewController.swift
//  CCIntegrationKit_Swift
//
//  Created by Ram Mhapasekar on 7/7/17.
//  Copyright © 2017 Ram Mhapasekar. All rights reserved.
//

import UIKit

class CCResultViewController: UIViewController {

    var transStatus = String()
    
    let resultLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(transStatus)
        self.view.addSubview(resultLable)
        resultLable.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        resultLable.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        self.resultLable.text = transStatus
        self.resultLable.reloadInputViews()
    }
}
