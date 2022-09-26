//
//  Model.swift
//  Messenger
//
//  Created by Ivan Pavlov on 04.09.2022.
//

import Foundation

final class Model {
    
    var currentClient: (String, String)? {
        return client != nil ? (client!.login, client!.password) : nil
    }

    // MARK: - Main Properties
    
    private let communicator: ServerCommunicator
    private var parser: Parser
    private var dataBase: DataBasable
    //private var keyChain: KeyChain
    private var client: Client?
    

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
        
        //self.keyChain = KeyChain()
        let username = UserDefaults.standard.string(forKey: UserDefaultsKeys.username)
        let id = UserDefaults.standard.integer(forKey: UserDefaultsKeys.id)
        let login = UserDefaults.standard.string(forKey: "login")
        let password = UserDefaults.standard.string(forKey: "password")
        if let username = username,
           let login = login,
           let password = password,
           id != 0
        {
//            self.client = keyChain.getClient(with: String(id), nickname: username)
            self.client = Client(name: username, id: id, login: login, password: password)
        }

        self.dataBase = DataBase(
            readingQueue: DispatchQueue.global(qos: .userInitiated),
            writingQueue: DispatchQueue.global(qos: .background))
        
        self.handlerQueue = handlerQueue
        
        self.communicator = ServerCommunicator(
            host: ServerAdress.host,
            port: ServerAdress.port)

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
        handlerStorage.loginHandler = { [weak self] (response) in
            switch(response.response) {
            case let .success(id, nickname):
                let client = Client(name: nickname, id: id, login: username, password: password)
                self?.client = client
                //self?.keyChain.saveClient(client)
                
                self?.dataBase.openDataBase(for: username)
                UserDefaults.standard.set(id, forKey: UserDefaultsKeys.id)
                UserDefaults.standard.set(nickname, forKey: UserDefaultsKeys.username)
                UserDefaults.standard.set(password, forKey: "password")
                UserDefaults.standard.set(username, forKey: "login")
            default:
                break
            }
            completionHandler(response)
        }
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
        handlerStorage.regHandler = { [weak self] (response) in
            switch(response.response) {
            case let .success(id):
                let client = Client(name: name, id: id, login: username, password: password)
                self?.client = client
                self?.dataBase.openDataBase(for: username)
                //self?.keyChain.saveClient(client)
                UserDefaults.standard.set(password, forKey: "password")
                UserDefaults.standard.set(username, forKey: "login")
                UserDefaults.standard.set(id, forKey: UserDefaultsKeys.id)
                UserDefaults.standard.set(name, forKey: UserDefaultsKeys.username)
            default:
                break
            }
            completionHandler(response)
        }
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
    
    func createPrivateChat(with user_id: Int) {
        if let message = ("#createchat name \(user_id)\n").data(using: .ascii) {
            communicator.send(message: message)
        }
    }
    
    func createPublicChat(with users_id: [Int], name: String) {
        var usersIDString = String()
        users_id.forEach { usersIDString += String($0) + " " }
        if let message = ("#createchat \(name) \(usersIDString)\n").data(using: .ascii) {
            communicator.send(message: message)
        }
    }
    
    func chatMembers(of chatID: Int, completionHandler: @escaping ChatMembersHandler)  {
        if let message = ("#chatMembers \(chatID)\n").data(using: .ascii) {
            handlerStorage.chatMembersHandler = completionHandler
            communicator.send(message: message)
        }
    }

    func deleteCache(of chatID: Int) {
        
    }

    func deleteAllCache() {
        
    }
    
    func getMemoryUsedAndDeviceTotalInMegabytes() -> (Float, Float) {
        
        // c-style coding
        
        var used_megabytes: Float = 0
        
        let total_bytes = Float(ProcessInfo.processInfo.physicalMemory)
        let total_megabytes = total_bytes / 1024.0 / 1024.0
        
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(
                    mach_task_self_,
                    task_flavor_t(MACH_TASK_BASIC_INFO),
                    $0,
                    &count
                )
            }
        }
        
        if kerr == KERN_SUCCESS {
            let used_bytes: Float = Float(info.resident_size)
            used_megabytes = used_bytes / 1024.0 / 1024.0
        }
        
        return (used_megabytes, total_megabytes)
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
            }
        case .register:
            if let handler = handlerStorage.regHandler,
               let data = data as? Registration
            {
                handlerQueue.async { handler(data) }
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
        case .findUser:
            if let data = data as? FindUserID,
               let handler = handlerStorage.findUserIDHandler
            {
                handlerQueue.async { handler(data.response) }
            }
        case .chatMembers:
            if let data = data as? Users,
               let handler = handlerStorage.chatMembersHandler
            {
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
    typealias FindUserIDHandler = (FindUserID.Response) -> Void
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
        var chatMembersHandler: ChatMembersHandler?
        
    }
    
    // MARK: - Server Address
    
    private enum ServerAdress {
        
        static let host = "185.204.0.32"
        static let port: UInt16 = 50000
        
    }
    
    // MARK: - User Defaults
    
    private enum UserDefaultsKeys {
        
        static let username = "username"
        static let id = "id"
        
    }

}
