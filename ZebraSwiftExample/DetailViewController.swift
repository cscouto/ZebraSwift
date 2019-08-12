//
//  DetailViewController.swift
//  ZebraSwiftExample
//
//  Created by COUTO, TIAGO [AG-Contractor/1000] on 8/12/19.
//  Copyright © 2019 Couto Code. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    var data: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = data
    }

}
