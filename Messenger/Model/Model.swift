//
//  Model.swift
//  Messenger
//
//  Created by Ivan Pavlov on 04.09.2022.
//

import Foundation

final class Model {

    // MARK: - User

    var user = Client(name: "", tag: "", password: "") {
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
    
    // These ones usually don't depend on user's actions.
    // So they can come at any time thus we need to have them
    // Within the model.
    var onReceivedMessages: (([Message]) -> Void)?//IncomingMessageHandler?
    var onReceivedChats: (([Chat]) -> Void)?//IncomingChatHandler?
    
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
        if let message = ("#register \(name) \(username) \(password)\n").data(using: .ascii) {
            communicator.send(message: message)
        }
    }

    func chats() {
        if dataBase.hasTable(with: "Chats") {
            dataBase.readChats() { [weak self] (data) in
                self?.handlerQueue.async {
                    self?.onReceivedChats?(data.value)
                }
            }
        } else if let message = ("#chats\n").data(using: .ascii) {
            dataBase.createChatsTable()
            communicator.send(message: message)
        }
    }

    func messages(for chatID: Int) {//, completionHandler: @escaping MessagesHandler) {
        if dataBase.hasTable(with: "Messages\(chatID)") {
            dataBase.readMessages(for: chatID) { [weak self] (data) in
                self?.handlerQueue.async { self?.onReceivedMessages?(data.value) }//completionHandler(data) }
            }
        } else if let message = ("#history \(chatID)\n").data(using: .ascii) {
            dataBase.createMessagesTable(for: chatID)
            communicator.send(message: message)
        }
    }

    func sendMessage(text: String, chatID: Int) {
        if let message = ("#message \(chatID) {\(text)}\n").data(using: .ascii) {
            communicator.send(message: message)
        }
    }
    
    func lastMessage(for chatID: Int, completionHandler: @escaping LastMessageHandler) {
        if let message = ("#lastmessage \(chatID)\n").data(using: .ascii) {
            handlerStorage.lastMessageHandler = completionHandler
            communicator.send(message: message)
        }

    }
    
    func findUserID(with nickname: String, completionHandler: @escaping FindUserIDHandler) {
        if let message  = ("#findUser \(nickname)\n").data(using: .ascii) {
            handlerStorage.findUserIDHandler = completionHandler
            communicator.send(message: message)
        }
    }
    
    func createPrivateChat(with userID: Int) {
        if let message = ("#createchat name \(userID)\n").data(using: .ascii) {
            communicator.send(message: message)
        }
    }
    
    func createPublicChat(with usersID: [Int], name: String) {
        var usersIDString = String()
        usersID.forEach { usersIDString += String($0) + " " }
        if let message = ("#createchat \(name) \(usersIDString)\n").data(using: .ascii) {
            communicator.send(message: message)
        }
    }
    
    func chatMembers(of chatID: Int, completionHandler: @escaping ChatMembersHandler)  {
        if dataBase.hasTable(with: "Chatmembers\(chatID)") {
            dataBase.readChatMembers(of: chatID) { [weak self] (data) in
                self?.handlerQueue.async { completionHandler(data) }
            }
        } else if let message = ("#chatmembers \(chatID)\n").data(using: .ascii) {
            dataBase.createChatMembers(of: chatID)
            handlerStorage.chatMembersHandler[chatID] = completionHandler
            communicator.send(message: message)
        }
    }
    
    func deleteCache(of chatID: Int) {
        
    }

    func deleteAllCache() {
        
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
        case .chats, .incomingChat:
            if let data = data as? Chats
            {
                dataBase.writeChats(data: data)
                handlerQueue.async { [weak self] in
                    self?.onReceivedChats?(data.value)
                }
            }
        case .history:
            if let data = data as? Messages,
               let chatID = data.value.first?.chatID
            {
                dataBase.writeMessages(data: data, to: chatID)
                handlerQueue.async { [weak self] in
                    self?.onReceivedMessages?(data.value)
                    print(data.value)
                }
            }
        case .incomingMessage:
            if let data = data as? Messages,
               let id = data.value.first?.chatID
            {
                guard dataBase.hasTable(with: "Messages\(id)") else {
                    dataBase.createMessagesTable(for: id)
                    communicator.send(message: ("#history \(id)\n").data(using: .ascii)!)
                    return
                }
                dataBase.writeMessages(data: data, to: id)
                handlerQueue.async { [weak self] in
                    self?.onReceivedMessages?(data.value)
                }
            }
        case .lastMessage:
            if let data = data as? LastMessage,
               let handler = handlerStorage.lastMessageHandler
            {
                dataBase.writeLastMessage(data)
                handlerQueue.async { handler(data) }
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
    typealias LastMessageHandler = (LastMessage) -> Void
    typealias FindUserIDHandler = (FindUserID) -> Void
    typealias ChatMembersHandler = (Users) -> Void
    typealias IncomingChatHandler = (Chat) -> Void
    typealias IncomingMessageHandler  = (Message) -> Void

    private struct HandlersStorage {
        
        var regHandler: RegistrationHandler?
        var loginHandler: LoginHandler?
        var chatsHandler: ChatsHandler?
        var messagesHandler = [Int: MessagesHandler]()
        var lastMessageHandler: LastMessageHandler?
        var findUserIDHandler: FindUserIDHandler?
        var chatMembersHandler = [Int: ChatMembersHandler]()
        
    }

}
