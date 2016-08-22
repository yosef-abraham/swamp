//
//  ViewController.swift
//  swampapp
//
//  Created by Yossi Abraham on 18/08/2016.
//  Copyright © 2016 Yossi Abraham. All rights reserved.
//

import UIKit
import Swamp

class ViewController: UIViewController, SwampSessionDelegate {
    var session: SwampSession?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        session = SwampSession(realm: "realm1", transport: WebSocketSwampTransport(wsEndpoint: NSURL(string: "ws://localhost:8080/ws")!))

        session!.delegate = self
        session!.connect()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func swampSessionConnected(session: SwampSession, sessionId: Int) {
        print("Session connected.. session ID is \(sessionId)")
    }
    
    func swampSessionEnded(reason: String) {
        print("Session ended, reason: \(reason)")
    }
    
    func swampSessionHandleChallenge(challenge: String) -> String {
        return "bullshit"
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        print("Ending session")
        session?.disconnect()
    }
}

