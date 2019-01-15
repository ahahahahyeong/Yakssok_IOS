
import UIKit

class BoardWriteViewController: UIViewController,BoardProtocol {
    
    var boardProtocol: BoardProtocol?
    
    let SERVER_ADDRESS : String = "http://172.30.1.30:8080/Yakssok"
    var type : String?
    var subject : String?
    var contents : String?
    
    @IBOutlet weak var type_info: UILabel!
    @IBOutlet weak var write_title: UITextField!
    @IBOutlet weak var write_contents: UITextView!

    func setBoard(board: Board?) {
        if let obj = board {
            NSLog("글 작성 전 타입 전달 받음: \(obj.type!)")
            type = obj.type
        }else {
            NSLog("전달못받음")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TextView 테두리 지정 코드
        self.write_contents.layer.borderWidth = 1.0
        self.write_contents.layer.borderColor = UIColor.black.cgColor
        if type == "notice" {
            type_info.text = "공지사항"
        }else if type == "share"{
            type_info.text = "팁&공유게시판"
        }else if type == "free" {
            type_info.text = "자유게시판"
        }
    }
    
    @IBAction func btn_delete(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_wirte(_ sender: Any) {
        subject = write_title.text
        contents = write_contents.text
        NSLog("글작성제목 \(subject!), 내용 \(contents!)")
        boardWriteLoad()
        navigationController?.popViewController(animated: true)
    }
    
    func boardWriteLoad(){
        
        let defaultSession = URLSession(configuration: .default)
        var dataTask : URLSessionDataTask?
        let urlComponents = URLComponents(string: SERVER_ADDRESS + "/mBoard/\(type!)/write")
        
        guard let url = urlComponents?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //!!!로그인 구현되면 m_idx 수정해야함!!!!
        let body = "m_idx=1&title=\(subject!)&contents=\(contents!)".data(using: String.Encoding.utf8)
        request.httpBody = body
        
        dataTask = defaultSession.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("통신에러! 에러메시지:"+error.localizedDescription)
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                NSLog("작성완료!"+String(data: data, encoding: .utf8)!)
            }
            self.boardProtocol?.setBoard(board: nil)
        }
        dataTask?.resume()
    }
}
