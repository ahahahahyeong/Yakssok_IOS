
class Member: Codable {
    
    var m_idx: Int?
    var type: Int?
    var id: String?
    var pw: String?
    var nickname: String?
    var name: String?
    var age: Int?
    var gender: Int?
    var tel: String?
    var email: String?
    var address: String?
    var joinDate: String?
    var point: Int?
}

protocol MemberProtocol {
    func setMember(member: Member?)
}
