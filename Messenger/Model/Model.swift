//
//  Model.swift
//  Messenger
//
//  Created by Ivan Pavlov on 04.09.2022.
//

import Foundation

final class Model {
    
    // MARK: - Main Properties
    
    private let communicator: ServerCommunicator
    private var parser: Parser
    
    //MARK: - Callbacks
    
    var onLogin: ((String) -> Void)?
    
    // MARK: - Initialization
    
    init() {
        let host = "185.204.0.32"
        let port = 1119 as UInt16
        self.parser = Parser()
        self.communicator = ServerCommunicator(host: host, port: port)
        self.communicator.onDidReceiveData = { [weak self] (data) in
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
    
    // MARK: - Processing Callback
    
    private func callBack(for command: Command, and message: String) {
        switch(command) {
        case .login:
            onLogin?(message)
        default:
            print("Ooops...Nobody cares about this command:\n\(command)")
        }
    }
    
    // MARK: - Processing Data
    
    private func didReceiveData(data: Data) {
        parser.parse(data: data) { [weak self] (command, message) in
            print(command, message)
            self?.callBack(for: command, and: message)
        }
    }
    
}
