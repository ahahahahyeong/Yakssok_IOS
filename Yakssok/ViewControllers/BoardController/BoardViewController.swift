
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
    
    let SERVER_ADDRESS : String = "http://172.30.1.23:8080/Yakssok"
    
    func setBoard(board: Board?) {
        if let obj = board {
            NSLog("전달받은 인덱스: -> \(obj.b_idx), 전달받은 타입: -> \(obj.type)")
            type = obj.type
            b_idx = obj.b_idx
        } else {
            NSLog("객체가 전달되지 않았습니다.")
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
            //self.performSegue(withIdentifier: "DeleteView", sender: sender)
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
        
        let defaultSession = URLSession(configuration: .default)
        //URLSession 객체를 통해 통신을 처리할 수 있는 테스크 변수 선언
        var dataTask : URLSessionDataTask?
        //url 문자열을 기반으로 다양한 작업을 처리할 수 있는 객체를 생성
        let urlComponents = URLComponents(string: SERVER_ADDRESS + "/mBoard/\(type!)/delete")
        //urlComponents 객체의 쿼리스트링을 지정하는 방법 (? 생략 후 키=벨류$키=벨류)
        //urlComponents?.query
        
        //guard let => 변수가 유효한지 확인할 수 있는 변수 유효하지 않다면 else~! (if let) 사용해도 댐
        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        //요청방식 설정
        request.httpMethod = "POST"
        //요청 데이터 설정
        let body = "b_idx=\(b_idx!)".data(using: String.Encoding.utf8)
        request.httpBody = body
        
        dataTask = defaultSession.dataTask(with: request) { data, response, error in
            
            if let error = error {
                NSLog("통신에러발생")
                //error.localizedDescription 어떤 에러가 바랭했느지 확인할 수 있음
                NSLog("에러 메시지 :"+error.localizedDescription)
                //data => 서버로부터 넘어온 데이터
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200{
                NSLog(String(data: data, encoding: .utf8)!)
                let resultString = String(data: data, encoding: .utf8)
                NSLog("삭제 결과->\(resultString)")
            }
        }
        //datatask 객체는 일시중지 상태로 생성되며 반드시 resume 메소드를 호출해야한 실행됨
        dataTask?.resume()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        board_view.type = type
        if segue.identifier == "ModifyView" {
            let boardModify : BoardModifyViewController = segue.destination as! BoardModifyViewController
            boardModify.setBoard(board: board_view)
    }


    }
    
    

}
