
import UIKit

class MemberRegistViewController: UIViewController  {
    
    var id : String?
    var pw : String?
    var nickname : String?
    var name : String?
    var age : Int?
    var gender : Int?
    var tel : String?
    var email : String?
    var address : String?
    
    var member : Member = Member()
    
    @IBOutlet weak var IdField: UITextField!
    @IBOutlet weak var PwField: UITextField!
    @IBOutlet weak var PwCheckField: UITextField!
    @IBOutlet weak var NicknameField: UITextField!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var AgeField: UITextField!
    @IBOutlet weak var GenderSegmente: UISegmentedControl!
    @IBOutlet weak var TelField: UITextField!
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var Address1: UITextField!
    @IBOutlet weak var Address2: UITextField!
    @IBOutlet weak var Address3: UITextField!
    
    @IBOutlet weak var IdCheck: UILabel!
    @IBOutlet weak var PwCheck: UILabel!
    @IBOutlet weak var NickCheck: UILabel!
    
    let SERVER_ADDRESS : String = "http://172.30.116.204:8080/Yakssok"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    @IBAction func IdAction(_ sender: UITextField) {
        id = IdField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if id?.isEmpty == true || id == "" {
            IdCheck.text = "필수사항입니다."
            IdCheck.textColor = UIColor.red
        }
        
        var defaultSession = URLSession(configuration: .default)
        var dataTask : URLSessionDataTask?
        var urlComponents = URLComponents(string: SERVER_ADDRESS + "/member/mCheckId")
        
        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        let body = "id=\(id!)".data(using: String.Encoding.utf8)
        request.httpBody = body
        
        dataTask = defaultSession.dataTask(with: request) { data, response, error in
            
            if let error = error {
                NSLog("에러 메시지 :"+error.localizedDescription)
                //data => 서버로부터 넘어온 데이터
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200{
                var JSonData : [String:Int]?
                JSonData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Int]
                if let result = JSonData {
                    if (self.id == "") {
                        DispatchQueue.main.async {
                            self.IdCheck.text = "필수사항입니다."
                            self.IdCheck.textColor = UIColor.red
                        }
                    }else if (result["count"] == 1 ) {
                        DispatchQueue.main.async {
                        self.IdCheck.text = "중복 또는 탈퇴한 아이디 입니다."
                        self.IdCheck.textColor = UIColor.red
                        }
                    }else if (result["count"] == 0){
                        DispatchQueue.main.async {
                        self.IdCheck.text = "멋진아이디네요!"
                        self.IdCheck.textColor = UIColor.blue
                        self.id = self.IdField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        }
                    }
                }
                
            }
        }
        dataTask?.resume()
    }
    
    
    @IBAction func PasswordAction(_ sender: UITextField) {
        if PwField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" ||       PwCheckField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == ""{
            PwCheck.text = "비밀번호를 입력하세요."
            PwCheck.textColor = UIColor.red
        }else if PwField.text == PwCheckField.text {
            //패스워드 맞을때
            PwCheck.text = "비밀번호가 일치합니다."
            PwCheck.textColor = UIColor.blue
            self.pw = PwField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }else if PwField.text != PwCheckField.text {
            //패스워드 틀릴때
            PwCheck.text = "비밀번호가 일치하지 않습니다."
            PwCheck.textColor = UIColor.red
        
        }
    }
    @IBAction func NicknameCheck(_ sender: UITextField) {
        
        nickname = NicknameField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if nickname?.isEmpty == true || nickname == "" {
            NickCheck.text = "닉네임을 입력하세요.."
            NickCheck.textColor = UIColor.red
        }
        
        var defaultSession = URLSession(configuration: .default)
        var dataTask : URLSessionDataTask?
        var urlComponents = URLComponents(string: SERVER_ADDRESS + "/member/mCheckNick")
        
        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        let body = "nickname=\(nickname!)".data(using: String.Encoding.utf8)
        request.httpBody = body
        
        dataTask = defaultSession.dataTask(with: request) { data, response, error in
            
            if let error = error {
                NSLog("에러 메시지 :"+error.localizedDescription)
                //data => 서버로부터 넘어온 데이터
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200{
                var JSonData : [String:Int]?
                JSonData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Int]
                if let result = JSonData {
                    if (self.nickname == "") {
                        DispatchQueue.main.async {
                            self.NickCheck.text = "닉네임을 입력하세요."
                            self.NickCheck.textColor = UIColor.red
                        }
                    }else if (result["count"] == 1 ) {
                        DispatchQueue.main.async {
                            self.NickCheck.text = "이미 사용중인 닉네임입니다."
                            self.NickCheck.textColor = UIColor.red
                        }
                    }else if (result["count"] == 0){
                        DispatchQueue.main.async {
                            self.NickCheck.text = "멋진닉네임이네요!"
                            self.NickCheck.textColor = UIColor.blue
                            self.nickname = self.NicknameField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        }
                    }
                }
                
            }
        }
        dataTask?.resume()
        
    }
    
    
    @IBAction func FindAddressBtn(_ sender: Any) {
        
    }
    
    @IBAction func RegistBtn(_ sender: Any) {
    
        name = NameField.text!
        age = Int(AgeField.text!)
        nickname = NicknameField.text!
        gender = GenderSegmente.selectedSegmentIndex
        tel = TelField.text!
        email = EmailField.text!
        address = "\(Address1.text!),+\(Address2.text!),+\(Address3.text!)"

        NSLog("id = \(id!), pw =\(pw!), nickname=\(nickname!), name=\(name!)")
        Join()
        
    }

    
    func Join(){
        let defaultSession = URLSession(configuration: .default)
        var dataTask : URLSessionDataTask?
        var urlComponents = URLComponents(string: SERVER_ADDRESS + "/member/mJoin")
        
        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        let body = "id=\(id!)&pw=\(pw!)&name=\(name!)&age=\(age!)&nickname=\(nickname!)&gender=\(gender!)&tel=\(tel!)&email=\(email!)&address=\(address!)".data(using: String.Encoding.utf8)
        request.httpBody = body
        
        dataTask = defaultSession.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("통신에러 발생! 에러메시지!:" + error.localizedDescription)
            }else if let data = data, let response = response as?
                HTTPURLResponse, response.statusCode == 200 {
                NSLog(String(data: data, encoding: .utf8)!)
                do{
                    self.member = try JSONDecoder().decode(Member.self, from: data)
                    NSLog("회원가입정보 결과->\(self.member.nickname)")
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
