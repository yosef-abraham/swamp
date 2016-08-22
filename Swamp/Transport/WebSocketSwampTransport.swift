//
//  WebSocketTransport.swift
//  swamp
//
//  Created by Yossi Abraham on 18/08/2016.
//  Copyright © 2016 Yossi Abraham. All rights reserved.
//

import Foundation
import Starscream

public class WebSocketSwampTransport: SwampTransport, WebSocketDelegate {
    
    enum WebsocketMode {
        case Binary, Text
    }
    
    public var delegate: SwampTransportDelegate?
    let socket: WebSocket
    let mode: WebsocketMode
    
    private var disconnectionReason: String?
    
    public init(wsEndpoint: NSURL){
        self.socket = WebSocket(url: wsEndpoint, protocols: ["wamp.2.json"])
        self.mode = .Text
        socket.delegate = self
    }
    
    // MARK: Transport
    
    public func connect() {
        self.socket.connect()
    }
    
    public func disconnect(reason: String) {
        self.disconnectionReason = reason
        self.socket.disconnect()
    }
    
    public func sendData(data: NSData) {
        if self.mode == .Text {
            self.socket.writeString(String(data: data, encoding: NSUTF8StringEncoding)!)
        } else {
            self.socket.writeData(data)
        }
    }
    
    // MARK: WebSocketDelegate
    
    public func websocketDidConnect(socket: WebSocket) {
        // TODO: Check which serializer is supported by the server, and choose self.mode and serializer
        delegate?.swampTransportDidConnectWithSerializer(JSONSwampSerializer())
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        delegate?.swampTransportDidDisconnect(error, reason: self.disconnectionReason)
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            self.websocketDidReceiveData(socket, data: data)
        }
    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        delegate?.swampTransportReceivedData(data)
    }
}
