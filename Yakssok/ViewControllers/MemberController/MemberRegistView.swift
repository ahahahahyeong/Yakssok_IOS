//
//  MemberRegistView.swift
//  Yakssok
//
//  Created by 402-30 on 03/01/2019.
//  Copyright © 2019 402-30. All rights reserved.
//

import UIKit

class MemberRegistView: UIViewController {
    
    var id : String?
    var pw : String?
    var nickname : String?
    var name : String?
    var age : Int?
    var gender : Int?
    var tel : String?
    var email : String?
    var address : String?
    
    var member: Member?
    
    @IBOutlet weak var IdTextField: UITextField!
    @IBOutlet weak var PwTextField: UITextField!
    @IBOutlet weak var PwConfirm: UITextField!
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var AgeTextField: UITextField!
    @IBOutlet weak var NickTextField: UITextField!
    @IBOutlet weak var ManTypeField: UISegmentedControl!
    @IBOutlet weak var HpTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PostcordField: UITextField!
    @IBOutlet weak var AddTextField: UITextField!
    @IBOutlet weak var PostSearchBtn: UIButton!
   
    let SERVER_ADDRESS : String = "http://172.30.1.27:8080/Yakssok"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func unwindFromPostCodeSelectionView(_ sender: UIStoryboardSegue) {
        print(#function)
    }
    
    @IBAction func JoinBtn(_ sender: Any) {
        
        id = self.IdTextField.text!
        pw = self.PwTextField.text!
        nickname = self.NickTextField.text!
        name = self.NameTextField.text!
        age = Int(self.AgeTextField.text!)
        gender = self.ManTypeField.selectedSegmentIndex
        tel = self.HpTextField.text!
        email = self.EmailTextField.text!
        address = self.AddTextField.text!
        
        join()
        
        if self.member == nil {
            let alert = UIAlertController(title: "회원가입", message: "다시 시도하세요", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: false, completion: nil)
        }else{
            navigationController?.popViewController(animated: true)
            let alert = UIAlertController(title: "회원가입", message: "회원가입 성공", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    func join(){
        NSLog("Join 서버접근")
        
        var defaultSession = URLSession(configuration: .default)
        //URLSession 객체를 통해 통신을 처리할 수 있는 테스크 변수 선언
        var dataTask : URLSessionDataTask?
        //url 문자열을 기반으로 다양한 작업을 처리할 수 있는 객체를 생성
        var urlComponents = URLComponents(string: SERVER_ADDRESS + "/member/mJoin")
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
                    self.member = try JSONDecoder().decode(Member.self, from: data)
                    NSLog("회원가입정보 결과->\(self.member?.nickname)")
                }catch {
                    let alert = UIAlertController(title: "회원가입", message: "회원가입실패", preferredStyle: UIAlertController.Style.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: false, completion: nil)
                }
                
            }
        }
        //datatask 객체는 일시중지 상태로 생성되며 반드시 resume 메소드를 호출해야한 실행됨
        dataTask?.resume()
    }
}
