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

struct Chats: ServerData {
    
    let value: [Chat]

}

struct Chat {
    var id: String
    var name: String
    var hostId: String?
}

struct Registration: ServerData {
    
    let response: RegistrationResponse
    
    init(response: Int) {
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
    
    init(response: Int) {
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

struct Message {
    
    let text: String
    let sender: Int
    let time: Date
    
}
