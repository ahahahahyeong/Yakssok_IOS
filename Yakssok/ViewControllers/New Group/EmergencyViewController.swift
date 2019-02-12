//
//  EmergencyViewController.swift
//  Yakssok
//
//  Created by 402-30 on 08/01/2019.
//  Copyright © 2019 402-30. All rights reserved.
//

import UIKit

class EmergencyViewController: UIViewController {
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    @IBAction func showView(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.0, animations: {
                self.firstView.alpha = 0.0
                self.secondView.alpha = 1.0
            })
        }
        else {
            UIView.animate(withDuration: 0.0, animations: {
                self.firstView.alpha = 1.0
                self.secondView.alpha = 0.0
            })
        }
    }
    
    
    


}
