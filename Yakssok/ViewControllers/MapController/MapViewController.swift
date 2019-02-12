
import UIKit
import WebKit

class MapViewController: UIViewController, WKUIDelegate, WKNavigationDelegate  {
    
    @IBOutlet weak var webView: WKWebView!
    
    
    override func loadView() {
        super.loadView()
        
        webView = WKWebView(frame: self.view.frame)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        self.view = self.webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "http://172.30.1.16:8080/mobile/API_Daum_Map_Drugstore/")
        let request = URLRequest(url: url!)
        webView.load(request)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    

}
