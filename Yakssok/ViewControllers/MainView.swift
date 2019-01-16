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
    @IBOutlet weak var LogoutBtn: UIButton!
    @IBOutlet weak var MemberInfoBtn: UIButton!
    @IBOutlet weak var WelcomNickName: UILabel!
    
    @IBOutlet weak var MemRegBtn: UIButton!
    
    var memberProtocol: MemberProtocol?
    var loginMember : Member?
    
    func setMember(member: Member?) {
        //if let obj = member {
        if let loginMember = member {
            NSLog("메인 전달받은 닉네임: -> \(loginMember.nickname) + \(loginMember.id)")
            if loginMember != nil {
            DispatchQueue.main.async {
                self.WelcomNickName.text = "\(String(loginMember.nickname!))님 환영합니다:)"
                self.LoginBtn.isHidden = true
                self.MemRegBtn.isHidden = true
                self.MemberInfoBtn.isHidden = false
                self.LogoutBtn.isHidden = false
                self.loginMember = member!
                }
            }else if loginMember == nil {
                self.loginMember = nil
                let alert = UIAlertAction(title: "로그인 실패", style: UIAlertAction.Style.default, handler: nil)
            }else{
                NSLog("메인 정보가 전달되지 않았습니다.")
            }
        }
    }
    

    @IBAction func ActionLogout(_ sender: Any) {
        
        loginMember = nil
        self.LoginBtn.isHidden = false
        self.MemRegBtn.isHidden = false
        self.LogoutBtn.isHidden = true
        self.MemberInfoBtn.isHidden = true
        self.WelcomNickName.text = ""
        NSLog("로그아웃됐니?\(loginMember?.nickname)")
    }
    
    
    override func viewDidLoad() {
        LoginBtn.isHidden = false
        super.viewDidLoad()
        //NSLog("로그인??\(loginMember = nil)")
        if self.loginMember != nil {
            NSLog("닐값이아닌디\(self.loginMember?.nickname)")
            LoginBtn.isHidden = true
            MemRegBtn.isHidden = true
            LogoutBtn.isHidden = false
            MemberInfoBtn.isHidden = false
            
        }else if self.loginMember == nil {
            NSLog("닐값인디")
            LoginBtn.isHidden = false
            MemRegBtn.isHidden = false
            LogoutBtn.isHidden = true
            MemberInfoBtn.isHidden = true
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("데이터 전달 전 prepare접근!!")
        if segue.identifier == "LoginNickName" {
            let loginViewController : LoginViewController = segue.destination as!
            LoginViewController
            loginViewController.memberProtocol = self
        }else if segue.identifier == "MemberModify"{
            let modifyController : MemberModifyController = segue.destination as!
            MemberModifyController
            modifyController.login = loginMember
            modifyController.memberProtocol = self

        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        //var member: Member? = Member()
//        //member = self.loginMember
//        NSLog("회원정보 수정페이지로 타입 전달!!! \(self.loginMember)")
//        self.memberProtocol?.setMember(member: self.loginMember)
//    }
    
    @IBAction func ModifyMember(_ sender: Any) {
        var member: Member? 
        member = self.loginMember
        NSLog("회원정보 수정페이지로 타입 전달!!! \(self.loginMember?.nickname)")
        self.memberProtocol?.setMember(member: member)
    }
}

