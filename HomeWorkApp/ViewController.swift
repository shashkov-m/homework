import UIKit
import WebKit

class ViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!{
        didSet{
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth()
    }
    
    private func auth () {
        
        var urlComponents = URLComponents ()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem (name: "client_id", value: "7830063"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.130")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webView.load(request)
        
    }
}

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        let params = fragment.components(separatedBy: "&").map { $0.components(separatedBy: "=") }.reduce([String: String]()) { result, param in
            var dict = result
            let key = param[0]
            let value = param[1]
            dict[key] = value
            return dict
        }
        Session.session.token = params["access_token"] ?? ""
        print("Access Token: \(Session.session.token)")
        
        decisionHandler(.cancel)
        
        
        performSegue(withIdentifier: "authSuccess", sender: self)
    }
}
