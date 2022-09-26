//
//  User.swift
//  Messenger
//
//  Created by Ivan Pavlov on 04.09.2022.
//

import Foundation

protocol ServerData {}

struct Client: ServerData {
    
    var name: String
    var id: Int
    var login: String
    var password: String

}

struct Chat: ServerData, Comparable {
    
    var id: Int
    var name: String
    var hostId: Int
    var date: String
    var time: String
    var lastMessage: LastMessage?
    
    static func < (lhs: Chat, rhs: Chat) -> Bool {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let lhsDateString = lhs.lastMessage != nil ? lhs.lastMessage!.date : lhs.date
        let lhsTimeString = lhs.lastMessage != nil ? lhs.lastMessage!.time : lhs.time
        let rhsDateString = rhs.lastMessage != nil ? rhs.lastMessage!.date : rhs.date
        let rhsTimeString = rhs.lastMessage != nil ? rhs.lastMessage!.time : rhs.time
        guard
            let lhsDate = dateFormat.date(from: lhsDateString + " " + lhsTimeString),
            let rhsDate = dateFormat.date(from: rhsDateString + " " + rhsTimeString)
        else { return false }
        return lhsDate < rhsDate
    }
    
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let lhsDateString = lhs.lastMessage != nil ? lhs.lastMessage!.date : lhs.date
        let lhsTimeString = lhs.lastMessage != nil ? lhs.lastMessage!.time : lhs.time
        let rhsDateString = rhs.lastMessage != nil ? rhs.lastMessage!.date : rhs.date
        let rhsTimeString = rhs.lastMessage != nil ? rhs.lastMessage!.time : rhs.time
        guard
            let lhsDate = dateFormat.date(from: lhsDateString + " " + lhsTimeString),
            let rhsDate = dateFormat.date(from: rhsDateString + " " + rhsTimeString)
        else { return false }
        return lhsDate == rhsDate
    }
}

struct LastMessage: ServerData {
    var chatID: Int
    var text: String
    var date: String
    var time: String
}

struct Chats: ServerData {
    
    let value: [Chat]

}

struct Registration: ServerData {
    
    let response: RegistrationResponse
    
    init(response: Int) {
        if response == 0 {
            self.response = .success(response)
        } else {
            self.response = .usedLogin
        }
    }

    enum RegistrationResponse {
        case success(Int)
        case usedLogin
    }
}

struct Login: ServerData {
    
    let response: LoginResponse

    init(response: Int, nickname: String) {
        switch(response) {
        case -1:
            self.response = .wrongLogin
        case -2:
            self.response = .wrongPassword
        default:
            self.response = .success(response, nickname)
        }
    }
    
    enum LoginResponse {
        case success(Int, String)
        case wrongLogin
        case wrongPassword
    }
}

struct Messages: ServerData {
    
    let value: [Message]
    
}

struct Message: ServerData {
    
    let chatID: Int
    let text: String
    let senderID: Int
    let senderUsername: String
    let date: String
    let time: String
    
    func transformIntoLastMessage() -> LastMessage {
        let chatID = chatID
        let text = text
        let date = date
        let time = time
        return LastMessage(chatID: chatID, text: text, date: date, time: time)
    }

}

struct FindUserID: ServerData {
    
    let response: Response
    
    init(response: Int?) {
        guard let response = response else {
            self.response = .notFound
            return
        }
        self.response = response != -1 ? .found(response) : .notFound
    }

    enum Response {
        
        case notFound
        case found(Int)
        
    }

}

struct UnknownData: ServerData {
    
    let value: [String]

}

struct User: ServerData {
    
    let nickname: String
    let userID: Int
    
}

struct Users: ServerData {
    
    let value: [User]
    
}
