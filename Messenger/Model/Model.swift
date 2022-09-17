//
//  Model.swift
//  Messenger
//
//  Created by Ivan Pavlov on 04.09.2022.
//

import Foundation

final class Model {

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
        self.parser = Parser()
        self.dataBase = DataBase(
            readingQueue: DispatchQueue.global(qos: .userInitiated),
            writingQueue: DispatchQueue.global(qos: .background))
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
    
    // MARK: - Getting Chats List

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
    
    // MARK: - Getting Messages for a Chat
    
    func messages(for chatID: Int, completionHandler: @escaping MessagesHandler) {
        let condition = dataBase.hasTable(with: "Messages\(chatID)")
        print("COOOOONDITION: \(condition) for chatid: \(chatID)")
        if condition {
            print("CHECKING BIIIIIG")
            dataBase.readMessages(for: chatID) { [weak self] (data) in
                self?.handlerQueue.async { completionHandler(data) }
            }
        } else if let message = ("#history \(chatID)\n").data(using: .ascii) {
            dataBase.createMessagesTable(for: chatID)
            handlerStorage.messagesHandler = completionHandler
            communicator.send(message: message)
        }
    }

    private func saveAndSend(data: ServerData, for command: Command) {
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
                
                handlerQueue.async { handler(data) }
                dataBase.writeChats(data: data)
            }
        case .history:
            if let handler = handlerStorage.messagesHandler,
               let data = data as? Messages,
               let chatID = data.value.first?.chatID
            {
 
                print("here?")
                handlerQueue.async { handler(data) }
                dataBase.writeMessages(data: data, to: chatID)
            }
        default:
            return
        }
    }

    // MARK: - Processing Data
    
    private func didReceiveData(data: Data) {
        parser.parse(data: data)
        //print(String(data: data, encoding: .ascii))
    }
    
    private func dataDidCooked(command: String, data: String) {
        print("did cooked: ", data)
        let command = defineCommand(command)
        let data = retrieveData(from: data, for: command)
        saveAndSend(data: data, for: command)
    }

    private func defineCommand(_ command: String) -> Command {
        switch(command) {
        case "auth":
            return .login
        case "register":
            return .register
        case "chats":
            return .chats
        case "history":
            return .history
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
                let idString = separated[i]
                let name = separated[i+1]
                let hostIdString = separated[i+2]
                if let id = Int(idString),
                   let hostID = Int(hostIdString)
                {
                    chats.append(Chat(id: id, name: name, hostId: hostID))
                }
            }
            return Chats(value: chats)
        case .login:
            guard let response = Int(data) else { return Login(response: -1)}
            return Login(response: response)
        case .history:
            //print(data)
            let separated = mySepar(data)
            //print(separated)
            var messages = [Message]()
            for i in stride(from: 0, to: separated.count, by: 6) {
                let chatIDString = separated[i]
                let senderName = separated[i+1]
                let senderIDString = separated[i+2]
                let text = separated[i+3]
                let date = separated[i+4]
                let time = separated[i+5]
                if let chatID = Int(chatIDString),
                   let senderID = Int(senderIDString)
                {
                    messages.append(Message(
                        chatID: chatID,
                        text: text,
                        senderID: senderID,
                        senderUsername: senderName,
                        date: date,
                        time: time))
                }
            }
            return Messages(value: messages)
        default:
            
            // TODO: - Use all cases
            
            return Registration(response: -1)
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
    
    func mySepar(_ data: String) -> [String] {
        //print("data datishe: \(data)")
        var separeted = [String]()
        var flag = false
        var current = [Character]()
        for s in data {
            //print("on line: s: \(s) and flag: \(flag)")
            //if s == "{" {
             //   print("ITS INSIDE")
           // }
            //print("current lexeme: \(s)")
            if s == " " && !flag {
                separeted.append(String(current))
                current = []
                continue
            }
            if s == "{" {
                flag = true
                continue
            }
            if s == "}" {
                flag = false
                continue
            }
            current.append(s)
        }
        separeted.append(String(current))
        return separeted
    }

}
