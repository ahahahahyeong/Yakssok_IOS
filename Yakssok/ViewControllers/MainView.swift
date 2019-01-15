//
//  ViewController.swift
//  Yakssok
//
//  Created by 402-30 on 03/01/2019.
//  Copyright © 2019 402-30. All rights reserved.
//

import UIKit

class MainView: UIViewController, MemberProtocol {

    @IBOutlet weak var Mainjpg: UIButton!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    @IBOutlet weak var LoginBtn: UIButton!
    @IBOutlet weak var WelcomNickName: UILabel!
    
    @IBOutlet weak var MemRegBtn: UIButton!
    
    func setMember(member: Member?) {
        if let obj = member {
            NSLog("전달받은 닉네임: -> \(obj.nickname) + \(obj.id)")
            if obj != nil {
            DispatchQueue.main.async {
                self.WelcomNickName.text = "\(String(obj.nickname!))님 환영합니다:)"
                self.LoginBtn.setTitle("로그아웃", for: .normal)
                self.MemRegBtn.setTitle("회원정보", for: .normal)
                }
            }else if obj == nil {
                DispatchQueue.main.async {
                    self.LoginBtn.setTitle("로그인", for: .normal)
                    self.MemRegBtn.setTitle("회원가입", for: .normal)
                }
            }
        }else{
            NSLog("정보가 전달되지 않았습니다.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("데이터 전달 전 prepare접근!!")
        if segue.identifier == "LoginNickName" {
            let loginViewController : LoginViewController = segue.destination as!
            LoginViewController
            loginViewController.memberProtocol = self
        }
    }


}

