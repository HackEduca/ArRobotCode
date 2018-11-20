//
//  InstructionsViewController.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 22/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit
import WebKit

class InstructionsViewController: UIViewController {

    var instructionsWebView: WKWebView!
    var robotHexa: PlayerHexa = PlayerHexa();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up to listen to messages
        let contentController = WKUserContentController()
        contentController.add(self, name: "callback")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        // Create the webView
        instructionsWebView = WKWebView(frame: self.view.bounds, configuration: config)
        
        // Load the index.html
        let htmlPath = Bundle.main.path(forResource: "blocks-only", ofType: "html")
        let htmlUrl = URL(fileURLWithPath: htmlPath!, isDirectory: false)
        instructionsWebView.loadFileURL(htmlUrl, allowingReadAccessTo: htmlUrl)
        
        // Add it
        self.view.addSubview(instructionsWebView)
        
        // Add the delegtes
        instructionsWebView.uiDelegate = self
        instructionsWebView.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension InstructionsViewController: WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // Receive message from WebKit JS
        guard let response = message.body as? String else {
            print("Something is fishy")
            return
        }
        
        print("Message from WebKIT: ", response)
        var responseSplit = response.split(separator: " ")
        switch responseSplit[0] {
            case "run":
                print("")
            case "moveFront":
                self.robotHexa.moveFront()
                break
            case "moveBack":
                self.robotHexa.moveBack();
                break
            case "turnLeft":
                self.robotHexa.turnLeft()
                break
            case "turnRight":
                self.robotHexa.turnRight()
                break
            default:
                print("Invalid response from WebKit")
        }
    }
    
    func sendToJS(message msg: String) {
        instructionsWebView.evaluateJavaScript("fromIOS('hello from the ios')", completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //This function is called when the webview finishes navigating to the webpage.
        //We use this to send data to the webview when it's loaded.
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("Alert from WebKIT: " + message)
        completionHandler()
    }
    
}
