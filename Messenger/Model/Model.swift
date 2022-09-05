//
//  Model.swift
//  Messenger
//
//  Created by Ivan Pavlov on 04.09.2022.
//

import Foundation

final class Model {
    
    private let communicator: ServerCommunicator
    
    // MARK: - Initialization
    
    init() {
        let host = "185.204.0.32"
        let port = 3389 as UInt16
        self.communicator = ServerCommunicator(host: host, port: port)
        communicator.onDidReceiveData = { [weak self] (data) in
            self?.didReceiveData(data: data)
        }
    }

    // MARK: - Authorization on server

    func authorization(username: String, password: String) {
        communicator.start()
        if let message = ("#auth \(username) \(password)\n").data(using: .ascii) {
            communicator.send(message: message)
        }
    }

    // MARK: - Network Communication

    private func send(message: URLSessionWebSocketTask.Message) {

    }
    
    // MARK: - Processing Data
    
    private func didReceiveData(data: Data) {
        
    }
    
}
