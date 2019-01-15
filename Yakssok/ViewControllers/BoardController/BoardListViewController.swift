import UIKit

class BoardListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BoardProtocol{
    
    func setBoard(board: Board?) {
        self.boardLoad()
    }
    
    @IBOutlet weak var BoardTable: UITableView!
    @IBOutlet weak var type_info: UILabel!
    
    var board_list : Array<Board> = Array()
    var board : Board?
    
    var type : String?
    var b_idx : Int?
    
    let SERVER_ADDRESS : String = "http://172.30.1.30:8080/Yakssok"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.type == "free" {
            type = "free"
            type_info?.text = "자유게시판"
            boardLoad()
            
        }else if self.type == "share" {
            type = "share"
            type_info?.text = "팁&공유게시판"
            boardLoad()
            
        }else if self.type == "notice" || self.type_info.text == "Label" {
            type = "notice"
            type_info.text = "공지사항"
            boardLoad()
        }

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return board_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell : BoardCell = BoardTable.dequeueReusableCell(withIdentifier: "BoardCell", for: indexPath) as! BoardCell
            let row = indexPath.row
            
            cell.title.text = board_list[row].title!
            cell.nickname.text = board_list[row].nickname!
            cell.b_idx.text = String(board_list[row].b_idx!)
            cell.b_idx.isHidden = true
            
            
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        b_idx = board_list[row].b_idx!
        NSLog("b_idx : "+String(b_idx!))
        
        self.performSegue(withIdentifier: "DetailView", sender: self)
    }
    
    @IBAction func btn_notice(_ sender: Any) {
        type = "notice"
        type_info.text = "공지사항"
        boardLoad()
    }
    
    @IBAction func btn_share(_ sender: Any) {
        type = "share"
        type_info.text = "팁&공유"
        boardLoad()
    }
    
    @IBAction func btn_free(_ sender: Any) {
        type = "free"
        type_info.text = "자유게시판"
        boardLoad()
    }
    
    func boardLoad(){
        NSLog("접속\(self.type)")
        let defaultSession = URLSession(configuration: .default)
        var dataTask : URLSessionDataTask?
        let urlComponents = URLComponents(string:  SERVER_ADDRESS + "/mBoard/\(type!)")
        guard let url = urlComponents?.url else { return }
        NSLog("연결")
        dataTask = defaultSession.dataTask(with: url) {data, response, error in
            if let error = error {
                NSLog("통신에러!!! 에러 메시지 : "+error.localizedDescription)
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                self.board_list = try! JSONDecoder().decode(Array<Board>.self, from: data)
                NSLog("리스트 접속성공")
            
                DispatchQueue.main.async {
                    NSLog("화면갱신1")
                    self.BoardTable.reloadData()
                    NSLog("화면갱신2")
                }
            }
        }
        dataTask?.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var board : Board = Board()
        board.type = type
        if segue.identifier == "DetailView" {
            NSLog("타입 전달!!! \(board.type)")
            board.b_idx = b_idx
            let  boardView : BoardViewController = segue.destination as!
            BoardViewController
            boardView.setBoard(board: board)
        }else if segue.identifier == "WriteView" {
            NSLog("글쓰기 데이터 전달 \(board.type!)")
            //****로그인 구현 완료 되면 m_idx 보내야함!!!!!!!!
            let writeView : BoardWriteViewController = segue.destination as! BoardWriteViewController
            writeView.setBoard(board: board)
            writeView.boardProtocol = self
        }
    }
}
