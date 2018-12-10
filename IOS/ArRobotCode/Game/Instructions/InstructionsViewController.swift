//
//  InstructionsViewController.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 22/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit
import WebKit

import RxSwift
import RxCocoa


class InstructionsViewController: UIViewController {
    public var instructionsBehaviourSubject: BehaviorSubject<String> = BehaviorSubject(value: "")
    public var eventsBehaviourSubject      : BehaviorSubject<String> = BehaviorSubject(value: "")
    
    @IBOutlet public weak var backButton: UIButton!
    @IBOutlet public weak var statusTextView: UITextView!

    @IBOutlet private weak var actionBarView: UIView!
    @IBOutlet private weak var webView: UIView!
    private var instructionsWebView: WKWebView!
    
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
        self.webView.addSubview(instructionsWebView)
        
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
        if responseSplit.count == 0 {
            return;
        }
    
        // Publish instructions
        let possibleInstructions = ["run","moveFront", "moveFrontIf" ,"moveBack", "moveBackIf","turnLeft", "turnLeftIf", "turnRight", "turnRightIf"]
        if possibleInstructions.contains(String(responseSplit[0])) {
            self.instructionsBehaviourSubject.onNext(response)
        }
        
        // Publish events
        let possibleEvents = ["run","stop"]
        if possibleEvents.contains(String(responseSplit[0])) {
            self.eventsBehaviourSubject.onNext(response)
        }
    }
    
    func sendToJS(message msg: String) {
        instructionsWebView.evaluateJavaScript(msg) { (el, err) in
            print("Evaluating: ", msg)
            print(err)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //This function is called when the webview finishes navigating to the webpage.
        //We use this to send data to the webview when it's loaded.
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        // This is called when I have an alert
        completionHandler()
    }
    
}
