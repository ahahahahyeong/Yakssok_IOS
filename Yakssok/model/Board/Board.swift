
class Board : Codable {
    
    var type : String?
    var b_idx : Int?
    var m_idx : Int?
    var nickname : String?
    var title : String?
    var contents :String?
    var read_cnt : Int?
    var writeDate : String?
}


protocol BoardProtocol {
    func setBoard(board: Board?)
}
