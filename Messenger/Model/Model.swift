//
//  Model.swift
//  Messenger
//
//  Created by Ivan Pavlov on 04.09.2022.
//

import Foundation

final class Model {

    // MARK: - User
    
    var user = User(name: "", tag: "", password: "")
    
    // MARK: - Main Properties
    
    private let communicator: ServerCommunicator
    private var parser: Parser
    
    //MARK: - Handlers
    
    private let handlerQueue: DispatchQueue
    private var handlerStorage = HandlersStorage()
    
    // MARK: - Initialization
    
    init(handlerQueue: DispatchQueue) {
        self.parser = Parser()
        self.handlerQueue = handlerQueue
        self.communicator = ServerCommunicator(host: "185.204.0.32", port: (50000 as UInt16))
        
        self.communicator.onDidReceiveData = { [weak self] (data) in
            self?.didReceiveData(data: data)
        }
        self.parser.onCookedData = { [weak self] (commandString, dataString) in
            self?.dataDidCooked(command: commandString, data: dataString)
        }

        self.communicator.start()
    }

    // MARK: - Authorization on server

    func login(
        username: String,
        password: String,
        completionHandler: @escaping LoginHandler)
    {
        handlerStorage.loginHandler = completionHandler
        if let message = ("#auth \(username) \(password)\n").data(using: .ascii) {
            communicator.send(message: message)
        }
    }
    
    func registration(
        name: String,
        username: String,
        password: String,
        completionHandler: @escaping RegistrationHandler)
    {
        handlerStorage.regHandler = completionHandler
        if let message =
            ("#register \(name) \(username) \(password)\n").data(using: .ascii)
        {
            communicator.send(message: message)
        }
    }
    
    func chats(completionHandler: @escaping ChatsHandler) {
        handlerStorage.chatsHandler = completionHandler
        if let message = ("#chats\n").data(using: .ascii) {
            communicator.send(message: message)
        }
    }

    // MARK: - Processing Callbacks

    private func callCompletionHandler(for command: Command, and data: ServerData) {
        switch(command) {
        case .login:
            if let handler = handlerStorage.loginHandler,
               let data = data as? Login
            {
                handlerQueue.async { handler(data) }
            }
        case .register:
            if let handler = handlerStorage.regHandler,
               let data = data as? Registration
            {
                handlerQueue.async { handler(data) }
            }
        case .chats:
            if let handler = handlerStorage.chatsHandler,
               let data = data as? Chats
            {
                handlerQueue.async { handler(data) }
            }
        default:
            print("Ooops...Nobody cares about this command:\n\(command)")
        }
    }
    
    // MARK: - Processing Data
    
    private func didReceiveData(data: Data) {
        parser.parse(data: data)
    }
    
    private func dataDidCooked(command: String, data: String) {
        let command = defineCommand(command)
        let data = retrieveData(from: data, for: command)
        callCompletionHandler(for: command, and: data)
    }

    private func defineCommand(_ command: String) -> Command {
        switch(command) {
        case "auth":
            return .login
        case "register":
            return .register
        case "chats":
            return .chats
        default:
            print(command)
            return .unknown
        }
    }

    private func retrieveData(from data: String, for command: Command) -> ServerData {
        switch(command) {
        case .register:
            guard let response = Int(data) else { return Registration(response: -1) }
            return Registration(response: response)
        case .chats:
            let separated = data.components(separatedBy: " ")
            var chats = [Chat]()
            for i in stride(from: 0, to: separated.count, by: 3) {
                let id = separated[i]
                let name = separated[i+1]
                let hostId = separated[i+2]
                chats.append(Chat(id: id, name: name, hostId: hostId))
            }
            return Chats(value: chats)
        case .login:
            guard let response = Int(data) else { return Login(response: -1)}
            return Login(response: response)
        default:
            
            // TODO: - Use all cases
            
            return Registration(response: -1)
        }
    }
    
    // MARK: - Handlers Storage
    
    typealias RegistrationHandler = (Registration) -> Void
    typealias LoginHandler = (Login) -> Void
    typealias ChatsHandler = (Chats) -> Void
    
    private struct HandlersStorage {
        
        var regHandler: RegistrationHandler?
        var loginHandler: LoginHandler?
        var chatsHandler: ChatsHandler?
    
    }

}
