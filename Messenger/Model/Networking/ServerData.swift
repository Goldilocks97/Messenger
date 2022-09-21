//
//  User.swift
//  Messenger
//
//  Created by Ivan Pavlov on 04.09.2022.
//

import Foundation

protocol ServerData {}

struct User: ServerData {
    
    var name: String
    var tag: String
    var password: String

}

struct Chat: ServerData {
    var id: Int
    var name: String
    var hostId: Int
    var lastMessage: LastMessage?
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
    
    init(response: Int?) {
        if response == 0 {
            self.response = .success
        } else {
            self.response = .usedLogin
        }
    }

    enum RegistrationResponse {
        case success
        case usedLogin
    }
}

struct Login: ServerData {
    
    let response: LoginResponse

    init(response: Int?) {
        switch(response) {
        case -1:
            self.response = .wrongLogin
        case -2:
            self.response = .wrongPassword
        default:
            self.response = .success
        }
    }
    
    enum LoginResponse {
        case success
        case wrongLogin
        case wrongPassword
    }
}

struct Messages: ServerData {
    
    let value: [Message]
    
}

struct Message {
    
    let chatID: Int
    let text: String
    let senderID: Int
    let senderUsername: String
    let date: String
    let time: String
    
}

struct UnknownData: ServerData {
    
    let value: [String]

}
