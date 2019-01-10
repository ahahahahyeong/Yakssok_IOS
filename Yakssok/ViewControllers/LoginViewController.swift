//
//  LoginViewController.swift
//  Yakssok
//
//  Created by 402-30 on 07/01/2019.
//  Copyright © 2019 402-30. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var MainBtn: UIButton!
    
    @IBOutlet weak var IdTextField: UITextField!
    
    @IBOutlet weak var PwTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func SubmitBtn(_ sender: Any) {
    }
    
    @IBAction func FindBtn(_ sender: Any) {
    }
    //엔터 누를시 자동이동 함수
    @IBAction func IdTextField(_ sender: UITextField) {
        if sender.tag == 1 {
            PwTextField.becomeFirstResponder()
        }
    }
    
    
}
