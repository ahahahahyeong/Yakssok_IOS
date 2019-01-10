
import UIKit

class BoardViewController: UIViewController, BoardProtocol {

    @IBOutlet weak var view_type: UILabel!
    @IBOutlet weak var view_title: UILabel!
    @IBOutlet weak var view_read_cnt: UILabel!
    @IBOutlet weak var view_contents: UITextView!
    @IBOutlet weak var view_nickname: UILabel!

    @IBOutlet weak var view_writedate: UILabel!
    
    var board_view : Board = Board()
     var board_list : Array<Board> = Array()
    var type : String?
    var b_idx : Int?
    
    let SERVER_ADDRESS : String = "http://172.30.1.2:8080/Yakssok"
    
    func setBoard(board: Board?) {
        if let obj = board {
            NSLog("전달받은 인덱스: -> \(obj.b_idx), 전달받은 타입: -> \(obj.type)")
            type = obj.type
            b_idx = obj.b_idx
        } else {
            NSLog("Member 객체가 전달되지 않았습니다.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view_contents.isEditable = false
        
        NSLog("타입:\(type), 인덱스: \(b_idx) ")
        boardViewLoad()
        if type == "notice"{
            view_type.text = "공지사항"
        }else if type == "share"{
            view_type.text = "팁&공유게시판"
        }else if type == "free"{
            view_type.text = "자유게시판"
        }
    }
    
    @IBAction func btn_view_delete(_ sender: Any) {
        let alert = UIAlertController(title: "삭제", message: "게시물을 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let cancle = UIAlertAction(title: "cancle", style: UIAlertAction.Style.destructive, handler: nil)
  
        let ok = UIAlertAction(title: "ok", style: UIAlertAction.Style.default) { (UIAlertAction) in
           self.boardDeleteLoad()
            _ = self.navigationController?.popViewController(animated: true)
          
        }
        alert.addAction(cancle)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func boardViewLoad(){
        NSLog("상세글보기 서버 접근")
        let defaultSession = URLSession(configuration: .default)
        var dataTask : URLSessionDataTask?
        let urlComponents = URLComponents(string: SERVER_ADDRESS + "/mBoard/\(type!)/view/\(b_idx!)")
        
        guard let url = urlComponents?.url else { return }
        
        
        dataTask = defaultSession.dataTask(with: url) {data, response, error in
            if let error = error {
                NSLog("통신에러!!! 에러 메시지 : "+error.localizedDescription)
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                self.board_view = try! JSONDecoder().decode(Board.self, from: data)
                //NSLog("글쓴이: \(self.board_view.nickname)")
                NSLog("접속성공")
            }
            DispatchQueue.main.async {
                self.view_nickname.text = self.board_view.nickname
                self.view_title.text = self.board_view.title
                self.view_read_cnt.text = String(self.board_view.read_cnt!)
                self.view_contents.text = self.board_view.contents
                self.view_writedate.text = self.board_view.writeDate
                
            }
        }
        dataTask?.resume()
    }
    
    func boardDeleteLoad(){
        NSLog("글 삭제 서버접근")
        
        let url = URL(string: SERVER_ADDRESS + "/mBoard/\(type!)/delete")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "b_idx=\(b_idx!)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
        
//        var resultMap = [String : Int]()
//        resultMap["one"] = 1
//        resultMap["two"] = 2
//
//        NSLog("resultMap\(resultMap)")

        
//        let param = "b_idx=\(b_idx)"
//        let paramData = param.data(using: .utf8)
//
//        let url = URL(string: SERVER_ADDRESS + "/mBord/\(type!)/delete")!
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = paramData
//
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//
//        NSLog("딜리트 전송 url:\(url)")
//
//        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                NSLog("통신에러!!! 에러 메시지 : "+error.localizedDescription)
//                return;
//            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
//                self.board_view = try! JSONDecoder().decode(Board.self, from: data)
//                NSLog("접속성공")
//            }
//            DispatchQueue.main.async {
//
//
//            }
//        }
//        dataTask.resume()
    }
    
    
}
