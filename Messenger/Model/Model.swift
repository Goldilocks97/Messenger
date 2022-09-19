//
//  Model.swift
//  Messenger
//
//  Created by Ivan Pavlov on 04.09.2022.
//

import Foundation

final class Model {
    
    var onDidReceiveMessage: ((Message) -> Void)?

    // MARK: - User

    var user = User(name: "", tag: "", password: "") {
        didSet {
            dataBase.openDataBase(for: user.name)
        }
    }
    let selfID = 4
    
    // MARK: - Main Properties
    
    private let communicator: ServerCommunicator
    private var parser: Parser
    private var dataBase: DataBasable

    //MARK: - Handlers
    
    private let handlerQueue: DispatchQueue
    private var handlerStorage = HandlersStorage()
    
    // MARK: - Initialization
    
    init(handlerQueue: DispatchQueue) {
        self.dataBase = DataBase(
            readingQueue: DispatchQueue.global(qos: .userInitiated),
            writingQueue: DispatchQueue.global(qos: .background))
        
        self.handlerQueue = handlerQueue
        
        self.communicator = ServerCommunicator(host: "185.204.0.32", port: (50000 as UInt16))
        
        self.parser = Parser()
        self.parser.onCookedData = { [weak self] (command, data) in
            self?.dataDidCooked(command: command, data: data)
        }

        self.communicator.onDidReceiveData = { [weak self] (data) in
            self?.didReceiveData(data: data)
        }
        self.communicator.start()
    }

    // MARK: - Server API

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
        if dataBase.hasTable(with: "Chats") {
            dataBase.readChats() { [weak self] (data) in
                self?.handlerQueue.async { completionHandler(data) }
            }
        } else if let message = ("#chats\n").data(using: .ascii) {
            dataBase.createChatsTable()
            handlerStorage.chatsHandler = completionHandler
            communicator.send(message: message)
        }
    }
    
    func messages(for chatID: Int, completionHandler: @escaping MessagesHandler) {
        if dataBase.hasTable(with: "Messages\(chatID)") {
            dataBase.readMessages(for: chatID) { [weak self] (data) in
                self?.handlerQueue.async { completionHandler(data) }
            }
        } else if let message = ("#history \(chatID)\n").data(using: .ascii) {
            dataBase.createMessagesTable(for: chatID)
            handlerStorage.messagesHandler = completionHandler
            communicator.send(message: message)
        }
    }
    
    func sendMessage(_ message: Message) {
        if let messageServer = ("#message \(message.chatID) {\(message.text)}\n").data(using: .ascii) {
            dataBase.writeMessages(data: Messages(value: [message]), to: message.chatID)
            communicator.send(message: messageServer)
        }
    }

    // MARK: - Processing Data
    
    private func didReceiveData(data: Data) {
        parser.parse(data: data)
    }

    private func dataDidCooked(command: Command, data: ServerData) {
        switch(command) {
        case .login:
            if let handler = handlerStorage.loginHandler,
               let data = data as? Login
            {
                handlerQueue.async { handler(data) }
                user.name = "pinya2012"
            }
        case .register:
            if let handler = handlerStorage.regHandler,
               let data = data as? Registration
            {
                handlerQueue.async { handler(data) }
                user.name = "pinya2012"
            }
        case .chats:
            if let handler = handlerStorage.chatsHandler,
               let data = data as? Chats
            {
                dataBase.writeChats(data: data)
                handlerQueue.async { handler(data) }
            }
        case .history:
            if let handler = handlerStorage.messagesHandler,
               let data = data as? Messages,
               let chatID = data.value.first?.chatID
            {
                dataBase.writeMessages(data: data, to: chatID)
                handlerQueue.async { handler(data) }
            }
        case .incomingMessage:
            if let data = data as? Messages,
               let message = data.value.first
            {
                dataBase.writeMessages(data: data, to: message.chatID)
                handlerQueue.async { self.onDidReceiveMessage?(message) }
            }
        default:
            return
        }
    }

    // MARK: - Handlers Storage
    
    typealias RegistrationHandler = (Registration) -> Void
    typealias MessagesHandler = (Messages) -> Void
    typealias LoginHandler = (Login) -> Void
    typealias ChatsHandler = (Chats) -> Void

    private struct HandlersStorage {
        
        var regHandler: RegistrationHandler?
        var loginHandler: LoginHandler?
        var chatsHandler: ChatsHandler?
        var messagesHandler: MessagesHandler?

    }

}
