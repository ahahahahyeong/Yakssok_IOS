//
//  MemberModifyController.swift
//  Yakssok
//
//  Created by 402-30 on 03/01/2019.
//  Copyright © 2019 402-30. All rights reserved.
//

import UIKit

class MemberModifyController: UIViewController, MemberProtocol{
    
    var memberProtocol: MemberProtocol?
   // var member: Member?
    var login : Member?
    var newMember: Member = Member()
    
    var id : String?
    var pw : String?
    var nickname : String?
    var name : String?
    var age : Int?
    var gender : Int?
    var tel : String?
    var email : String?
    var address : String?
    
    
    @IBOutlet weak var modify_id: UITextField!
    @IBOutlet weak var modify_pw: UITextField!
    @IBOutlet weak var modify_pw_check: UITextField!
    @IBOutlet weak var modify_nickname: UITextField!
    @IBOutlet weak var modify_name: UITextField!
    @IBOutlet weak var modify_age: UITextField!
    @IBOutlet weak var modify_gender: UISegmentedControl!
    @IBOutlet weak var modify_email: UITextField!
    @IBOutlet weak var modify_tel: UITextField!
    @IBOutlet weak var modify_postcord: UITextField!
    @IBOutlet weak var modify_address: UITextField!
    @IBOutlet weak var PostSearchBtn: UIButton!
    
    let SERVER_ADDRESS : String = "http://192.168.10.93:8080/Yakssok"
    
    func setMember(member: Member?) {
        if let loginMember = member {
             NSLog("전달받은 수정페이지 닉네임: -> \(loginMember.nickname)")
            if loginMember != nil {
                self.login = loginMember

            }else if loginMember == nil {
                self.login = nil
                let alert = UIAlertAction(title: "로그인이 되어있지 않습니다.", style: UIAlertAction.Style.default, handler: nil)
            }else{
                NSLog("정보가 전달되지 않았습니다.")
            }
        }
    }
    
    @IBAction func modify_ok(_ sender: Any) {
        
        id = self.modify_id.text!
        pw = self.modify_pw.text!
        nickname = self.modify_nickname.text!
        name = self.modify_name.text!
        age = Int(self.modify_age.text!)
        gender = self.modify_gender.selectedSegmentIndex
        tel = self.modify_tel.text!
        email = self.modify_email.text!
        address = self.modify_address.text!
        
        modify()
        
        // 뒤로 되돌아가는 매소드(안드로이드의 finish)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {

        self.modify_id.text = self.login?.id
        self.modify_nickname.text = self.login?.nickname
        self.modify_name.text = self.login?.name
        self.modify_age.text = "\((self.login?.age!)!)"
        self.modify_gender.selectedSegmentIndex = (self.login?.gender!)!
        self.modify_email.text = self.login?.email
        self.modify_tel.text = self.login?.tel
        self.modify_address.text = self.login?.address
        
    }
    
    func modify(){
        NSLog("Modify 서버접근")
        
        var defaultSession = URLSession(configuration: .default)
        //URLSession 객체를 통해 통신을 처리할 수 있는 테스크 변수 선언
        var dataTask : URLSessionDataTask?
        //url 문자열을 기반으로 다양한 작업을 처리할 수 있는 객체를 생성
        var urlComponents = URLComponents(string: SERVER_ADDRESS + "/member/mModifyProfile")
        //urlComponents 객체의 쿼리스트링을 지정하는 방법 (? 생략 후 키=벨류$키=벨류)
        //urlComponents?.query
        
        //guard let => 변수가 유효한지 확인할 수 있는 변수 유효하지 않다면 else~! (if let) 사용해도 댐
        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        //요청방식 설정
        request.httpMethod = "POST"
        //요청 데이터 설정
        let body = "id=\(id)&pw=\(pw)&nickname=\(nickname)&name=\(name)&age=\(age)&gender=\(gender)&tel=\(tel)&email=\(email)&address=\(address)".data(using: String.Encoding.utf8)
        request.httpBody = body
        
        dataTask = defaultSession.dataTask(with: request) { data, response, error in
            
            if let error = error {
                NSLog("통신에러발생")
                //error.localizedDescription 어떤 에러가 발생했는지 확인할 수 있음
                NSLog("에러 메시지 :"+error.localizedDescription)
                //data => 서버로부터 넘어온 데이터
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200{
                NSLog(String(data: data, encoding: .utf8)!)
                //let resultString = String(data: data, encoding: .utf8)
                do{
                    self.newMember = try JSONDecoder().decode(Member.self, from: data)
                    NSLog("정보 결과->\(self.newMember.nickname)")
                    // 맴버 정보를 받아서 새로운 맴버에 담아서 메인 화면으로 보냄.
                    var member: Member = Member()
                    member = self.newMember
                    NSLog("타입 전달!!! \(member)")
                    self.memberProtocol?.setMember(member: member)
                }catch {
                    let alert = UIAlertController(title: "수정실패", message: "다시 시도하세요", preferredStyle: UIAlertController.Style.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: false, completion: nil)
                }
                
            }
        }
        //datatask 객체는 일시중지 상태로 생성되며 반드시 resume 메소드를 호출해야한 실행됨
        dataTask?.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("데이터 전달 전 prepare접근!!")
        if segue.identifier == "MemberModify" {
            let mainViewController : MainView = segue.destination as!
            MainView
            mainViewController.loginMember = login
            mainViewController.memberProtocol = self
        }
    }
    
    
}
