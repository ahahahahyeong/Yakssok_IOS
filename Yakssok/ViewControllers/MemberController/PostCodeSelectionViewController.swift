import UIKit
import WebKit

//웹뷰로 우편번호검색 띄어주기 - WebKit 임포트


//jsp로부터 보낸데이터를 받는 WKScriptMessageHandler 프로토콜
class PostCodeSelectionViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
  
  var webView: WKWebView?
  
    let indicator = UIActivityIndicatorView(style: .gray)
  var postCode = ""
  var address = ""
  let unwind = "unwind"
  
  override func loadView() {
    super.loadView()
    
    
    //message handler를 추가하는 메소드
    let contentController = WKUserContentController()
    contentController.add(self, name: "callBackHandler")
    
    let config = WKWebViewConfiguration()
    config.userContentController = contentController
    
    self.webView = WKWebView(frame: .zero, configuration: config)
    self.view = self.webView!
    self.webView?.navigationDelegate = self
    
    self.webView?.addSubview(indicator)
    indicator.center.x = UIScreen.main.bounds.width/2
    indicator.center.y = UIScreen.main.bounds.height/2
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard
        //깃으로 주소값을 받는이유 : 도메인정보가 없으면 주소값을받아 올 수 없음
        //앱에서 정적으로 웹뷰로 보여줄때 도메인정보가 없기때문에
        //우리는 도메인주소가 있어서 가능할듯 하나 일단 나중에 try 해보자
      let url = URL(string: "https://trilliwon.github.io/postcode/"),
      let webView = webView else { return }
    
    let request = URLRequest(url: url)
    webView.load(request)
    
    self.webView?.navigationDelegate = self
    indicator.startAnimating()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier, identifier == unwind {
      if let destination = segue.destination as? MemberRegistView {
        destination.PostcordField.text = postCode
        destination.AddTextField.text = address
      }
    }
  }
  
    //데이터를 받았을때 Invoke 하는 메서드
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    if let postCodData = message.body as? [String: Any] {
      postCode = postCodData["zonecode"] as? String ?? ""
      address = postCodData["addr"] as? String ?? ""
    }
    
    performSegue(withIdentifier: unwind, sender: nil)
  }
  
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    indicator.startAnimating()
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    indicator.stopAnimating()
  }
}
