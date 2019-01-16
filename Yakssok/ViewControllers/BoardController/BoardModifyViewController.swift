

import UIKit

class BoardModifyViewController: UIViewController,BoardProtocol {
    

    @IBOutlet weak var type_info: UILabel!
    @IBOutlet weak var modify_title: UITextField!
    @IBOutlet weak var modify_contents: UITextView!
    
    let SERVER_ADDRESS : String = "http://172.30.1.31:8080/Yakssok"
    var board : Board = Board()
    var boardProtocol : BoardProtocol?
    
    func setBoard(board: Board?) {
        if let obj = board{
            NSLog("수정페이지! 전달받은 타입:\(obj.type!),전달받은 타이틀\(obj.title!), 전달받은 인덱스\(obj.b_idx)")
            self.board.type = obj.type
            self.board.title = obj.title
            self.board.contents = obj.contents
            self.board.b_idx = obj.b_idx
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modify_contents.layer.borderWidth = 1.0
        self.modify_contents.layer.borderColor = UIColor.black.cgColor
        if board.type == "notice" {
            type_info.text = "공지사항"
        }else if board.type == "share" {
            type_info.text = "팁&공유게시판"
        }else if board.type == "free" {
            type_info.text = "자유게시판"
        }
        
        modify_title.text = self.board.title
        modify_contents.text = self.board.contents
        
    }
    @IBAction func btn_modify_delete(_ sender: Any) {
         navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_modify_ok(_ sender: Any) {
        self.board.title = modify_title.text
        self.board.contents = modify_contents.text
        boardModifyLoad()
        navigationController?.popViewController(animated: true)
        
    }
    
    func boardModifyLoad(){
        
        let defaultSession = URLSession(configuration: .default)
        var dataTask : URLSessionDataTask?
        let urlComponents = URLComponents(string: SERVER_ADDRESS + "/mBoard/\(self.board.type!)/modify")
        
        guard let url = urlComponents?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //!!!로그인 구현되면 m_idx 수정해야함!!!!
        let body = "m_idx=1&title=\(self.board.title!)&contents=\(self.board.contents!)&b_idx=\(self.board.b_idx!)".data(using: String.Encoding.utf8)
        request.httpBody = body
        
        dataTask = defaultSession.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("통신에러! 에러메시지:"+error.localizedDescription)
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                NSLog(String(data: data, encoding: .utf8)!)
            }
             self.boardProtocol?.setBoard(board: nil)
        }
        dataTask?.resume()
    }

}
