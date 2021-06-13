import UIKit
import WebKit

struct Scope:OptionSet {
    
    let rawValue:Int
    static let friends = Scope (rawValue: 1 << 1)
    static let photos = Scope (rawValue: 1 << 2)
    static let wall = Scope (rawValue: 1 << 13)
    static let groups = Scope (rawValue: 1 << 18)
    static let audio = Scope (rawValue: 1 << 3)
}

class VkAuth: UIViewController {
    let scope:Scope = [.friends, .photos, .audio, .wall, .groups]
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
            URLQueryItem(name: "scope", value: "\(scope.rawValue)"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.130")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webView.load(request)
        
    }
}

extension VkAuth: WKNavigationDelegate {
    
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
        Session.session.userId = params["user_id"] ?? ""
        print("Access Token: \(Session.session.token)")
        
        decisionHandler(.cancel)
        
        
        performSegue(withIdentifier: "authSuccess", sender: self)
    }
}
