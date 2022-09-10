//
//  Model.swift
//  Messenger
//
//  Created by Ivan Pavlov on 04.09.2022.
//

import Foundation

final class Model {
    
    typealias CompletionHandler = (Response) -> Void
    
    // MARK: - User
    
    var user = User(name: "", tag: "", password: "")
    
    // MARK: - Main Properties
    
    private let communicator: ServerCommunicator
    private var parser: Parser
    
    //MARK: - Handlers
    
    private let handlerQueue: DispatchQueue
    private var completionHandlers = [Command: CompletionHandler]()
    
    // MARK: - Initialization
    
    init(handlerQueue: DispatchQueue) {
        self.parser = Parser()
        self.handlerQueue = handlerQueue
        self.communicator = ServerCommunicator(host: "185.204.0.32", port: (50000 as UInt16))
        
        self.communicator.onDidReceiveData = { [weak self] (data) in
            self?.didReceiveData(data: data)
        }
        self.parser.onCookedData = { [weak self] (stringCommand, message) in
            if let command = self?.defineCommand(stringCommand) {
                self?.completionHandler(for: command, and: message)
            }
        }

        self.communicator.start()
    }

    // MARK: - Authorization on server

    func login(
        username: String,
        password: String,
        completionHandler: @escaping CompletionHandler)
    {
        completionHandlers[.login] = completionHandler
        if let message = ("#auth \(username) \(password)\n").data(using: .ascii) {
            communicator.send(message: message)
        }
    }
    
    func registration(
        name: String,
        username: String,
        password: String,
        completionHandler: @escaping CompletionHandler)
    {
        completionHandlers[.register] = completionHandler
        if let message =
            ("#register \(name) \(username) \(password)\n").data(using: .ascii)
        {
            communicator.send(message: message)
        }
    }

    // MARK: - Processing Callbacks

    private func completionHandler(for command: Command, and message: String) {
        switch(command) {
        case .login:
            if let handler = completionHandlers[.login] {
                handlerQueue.async { handler(.succes) }
            }
        case .register:
            if let handler = completionHandlers[.register] {
                handlerQueue.async { handler(.succes) }
            }
        default:
            print("Ooops...Nobody cares about this command:\n\(command)")
        }
    }
    
    // MARK: - Processing Data
    
    private func didReceiveData(data: Data) {
        parser.parse(data: data)
    }
    
    private func defineCommand(_ stringCommand: String) -> Command {
        switch(stringCommand) {
        case "auth":
            return .login
        case "register":
            return .register
        case "chats":
            return .chats
        default:
            return .unknown
        }
    }
    
}
