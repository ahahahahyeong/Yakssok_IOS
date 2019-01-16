//
//  LoginViewController.swift
//  Yakssok
//
//  Created by 402-30 on 07/01/2019.
//  Copyright © 2019 402-30. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var memberProtocol: MemberProtocol?
    
    var member: Member = Member()
    
    var id : String?
    var pw : String?

    @IBOutlet weak var MainBtn: UIButton!
    @IBOutlet weak var IdTextField: UITextField!
    @IBOutlet weak var PwTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    let SERVER_ADDRESS : String = "http://192.168.10.93:8080/Yakssok"
    
    @IBAction func btn_login(_ sender: Any) {
        id = IdTextField.text!
        pw = PwTextField.text!
        login()
        
        // 뒤로 되돌아가는 매소드(안드로이드의 finish)
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func FindBtn(_ sender: Any) {
    }
    //엔터 누를시 자동이동 함수
    @IBAction func IdTextField(_ sender: UITextField) {
        if sender.tag == 1 {
            PwTextField.becomeFirstResponder()
        }
    }
    
    func login(){
        NSLog("Login 서버접근")
        
        var defaultSession = URLSession(configuration: .default)
        //URLSession 객체를 통해 통신을 처리할 수 있는 테스크 변수 선언
        var dataTask : URLSessionDataTask?
        //url 문자열을 기반으로 다양한 작업을 처리할 수 있는 객체를 생성
        var urlComponents = URLComponents(string: SERVER_ADDRESS + "/member/mLogin")
        //urlComponents 객체의 쿼리스트링을 지정하는 방법 (? 생략 후 키=벨류$키=벨류)
        //urlComponents?.query
        
        //guard let => 변수가 유효한지 확인할 수 있는 변수 유효하지 않다면 else~! (if let) 사용해도 댐
        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        //요청방식 설정
        request.httpMethod = "POST"
        //요청 데이터 설정
        let body = "id=\(id!)&pw=\(pw!)".data(using: String.Encoding.utf8)
        request.httpBody = body
        
        dataTask = defaultSession.dataTask(with: request) { data, response, error in
            
            if let error = error {
                NSLog("통신에러발생")
                //error.localizedDescription 어떤 에러가 바랭했느지 확인할 수 있음
                NSLog("에러 메시지 :"+error.localizedDescription)
                //data => 서버로부터 넘어온 데이터
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200{
                NSLog(String(data: data, encoding: .utf8)!)
                //let resultString = String(data: data, encoding: .utf8)
                do{
                    self.member = try JSONDecoder().decode(Member.self, from: data)
                    NSLog("정보 결과->\(self.member.nickname)")
                    // 맴버 정보를 받아서 새로운 맴버에 담아서 메인 화면으로 보냄.
                    var member: Member = Member()
                    member = self.member
                    NSLog("메인 페이지로 타입 전달!!! \(member)")
                    self.memberProtocol?.setMember(member: member)
                }catch {
                    let alert = UIAlertController(title: "로그인실패", message: "다시 시도하세요", preferredStyle: UIAlertController.Style.alert)
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
