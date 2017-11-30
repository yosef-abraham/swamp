//
//  WebSocketTransport.swift
//  swamp
//
//  Created by Yossi Abraham on 18/08/2016.
//  Copyright © 2016 Yossi Abraham. All rights reserved.
//

import Foundation
import Starscream

open class WebSocketSwampTransport: SwampTransport, WebSocketDelegate {

    enum WebsocketMode {
        case binary, text
    }
    
    open var delegate: SwampTransportDelegate?
    let socket: WebSocket
    let mode: WebsocketMode
    
    fileprivate var disconnectionReason: String?
    
    public init(wsEndpoint: URL){
        self.socket = WebSocket(url: wsEndpoint, protocols: ["wamp.2.json"])
        self.mode = .text
        socket.delegate = self
    }
    
    // MARK: Transport
    
    open func connect() {
        self.socket.connect()
    }
    
    open func disconnect(_ reason: String) {
        self.disconnectionReason = reason
        self.socket.disconnect()
    }
    
    open func sendData(_ data: Data) {
        if self.mode == .text {
            self.socket.write(string: String(data: data, encoding: String.Encoding.utf8)!)
        } else {
            self.socket.write(data: data)
        }
    }
    
    // MARK: WebSocketDelegate

    public func websocketDidConnect(socket: WebSocketClient) {
        // TODO: Check which serializer is supported by the server, and choose self.mode and serializer
        delegate?.swampTransportDidConnectWithSerializer(JSONSwampSerializer())
    }

    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        guard let error = error as NSError? else { return }
        delegate?.swampTransportDidDisconnect(error, reason: self.disconnectionReason)
    }

    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        if let data = text.data(using: String.Encoding.utf8) {
            self.websocketDidReceiveData(socket: socket, data: data)
        }
    }

    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        delegate?.swampTransportReceivedData(data)
    }
}
