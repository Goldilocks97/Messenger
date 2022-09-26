//
//  Parser.swift
//  Messenger
//
//  Created by Ivan Pavlov on 05.09.2022.
//

import Foundation

struct Parser {
    
    // MARK: - Lexical Automate state
    private var state: AutomateState = .none
    
    // MARK: - LexicalAutomate buffers
    
    private var commandBuffer = [Character]()
    private var dataBuffer = [Character]()
    private var lexemesBuffer = [String]()
    
    // MARK: - CallBack
    
    var onCookedData: ((Command, ServerData) -> Void)?

    // MARK: - API
    
    mutating func parse(data: Data) {
        guard let str = String(data: data, encoding: .ascii) else {
            return
        }
        for char in str {
//            print("my char: \(char)")
            automate(char: char)
            if state == .space {
                state = .data
                lexemesBuffer.append(String(dataBuffer))
                dataBuffer = []
                continue
            }
            if state == .finished {
                state = .none
                if !dataBuffer.isEmpty {
                    lexemesBuffer.append(String(dataBuffer))
                }
                let (command, data) = retrieveServerData(from: lexemesBuffer, for: commandBuffer)
                onCookedData?(command, data)
                commandBuffer = []
                dataBuffer = []
                lexemesBuffer = []
            }
        }
    }

    // MARK: - LexicalAutomate
    
    mutating private func automate(char: Character) {
        switch(state) {
        case .none:
            if char == "#" {
                state = .command
            }
        case .command:
            if char == " " {
                state = .data
                return
            }
            if char == "\n" {
                state = .finished
                return
            }
            commandBuffer.append(char)
        case .data:
            if char == " " {
                state = .space
                return
            }
            if char == "{" {
                state = .openedBracket
                return
            }
            if char == "\n" {
                state = .finished
                return
            }
            dataBuffer.append(char)
        case .openedBracket:
            if char == "}" {
                state = .data
                return
            }
            dataBuffer.append(char)
        default:
            print("I don't know what to do...")
        }
    }
    
    // MARK: - Processing Data
    
    private func retrieveServerData(from lexemes: [String], for command: [Character]) -> (Command, ServerData) {
        let command = defineCommand(String(command))
        switch(command) {
        case .register:

            return (command, retrieveRegistr(from: lexemes))
        case .login:
            return (command, retrieveLogin(from: lexemes))
        case .chats, .incomingChat:
            return (command, Chats(value: retrieveChats(from: lexemes)))
        case .history, .incomingMessage:
            return (command, Messages(value: retrieveMessages(from: lexemes)))
        case .lastMessage:
            let lastMessage = retrieveLastMessage(from: lexemes)
            return (command, lastMessage)
        case .findUser:
            return (command, FindUserID(response: Int(lexemes[0])))
        case .chatMembers:
            return (command, Users(value: retrieveUsers(from: lexemes)))
        case .unknown:
            return (command, UnknownData(value: lexemes))
        }
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
        case "incomingMessage":
            return .incomingMessage
        case "lastmessage":
            return .lastMessage
        case "incomingChat":
            return .incomingChat
        case "findUser":
            return .findUser
        case "chatMembers":
            return .chatMembers
        default:
            //print("unkown command:", command)
            return .unknown
        }
    }
    
    private func retrieveRegistr(from lexemes: [String]) -> Registration {
        guard let res = Int(lexemes[0]) else {
            return Registration(response: -1)
        }
        return Registration(response: res)
    }
    
    private func retrieveLogin(from lexemes: [String]) -> Login {
        guard let id = Int(lexemes[0]) else {
            return Login(response: -1, nickname: "")
        }
        return Login(response: id, nickname: lexemes[1])
    }
    
    private func retrieveChats(from lexemes: [String]) -> [Chat] {
        var chats = [Chat]()
        for i in stride(from: 0, to: lexemes.count, by: 5) {
            guard
                let id = Int(lexemes[i]),
                let hostID = Int(lexemes[i+2])
            else { continue }
            let name = lexemes[i+1]
            let date = lexemes[i+3]
            let time = lexemes[i+4]
            chats.append(Chat(
                id: id,
                name: name,
                hostId: hostID,
                date: date,
                time: time))
        }
        return chats
    }
    
    private func retrieveUsers(from lexemes: [String]) -> [User] {
        var users = [User]()
        for i in stride(from: 0, to: lexemes.count, by: 2) {
            guard let id = Int(lexemes[i+1]) else {
                continue
            }
            let nickname = lexemes[i]
            users.append(User(nickname: nickname, userID: id))
        }
        return users
    }

    private func retrieveMessages(from lexemes: [String]) -> [Message] {
        var messages = [Message]()
        for i in stride(from: 0, to: lexemes.count, by: 6) {
            guard
                let chatID = Int(lexemes[i]),
                let senderID = Int(lexemes[i+2])
            else { continue }
            let senderName = lexemes[i+1]
            let text = lexemes[i+3]
            let date = lexemes[i+4]
            let time = lexemes[i+5]
            messages.append(Message(
                chatID: chatID,
                text: text,
                senderID: senderID,
                senderUsername: senderName,
                date: date,
                time: time))
        }
        return messages
    }
    
    private func retrieveLastMessage(from lexemes: [String]) -> LastMessage {
        guard
            !lexemes.isEmpty,
            let chatID = Int(lexemes[0])
        else {
            return LastMessage(chatID: -1, text: "", date: "", time: "")
        }
        let text = lexemes[3]
        let date = lexemes[4]
        let time = lexemes[5]
        return LastMessage(chatID: chatID, text: text, date: date, time: time)
    }

    // TODO: - Restrict length of buffers
    
    private enum ParserConstants {
        
        static let bufferLength = 1024
        
    }
    
    // MARK: - Automate States
    
    private enum AutomateState {
        case finished
        case space
        case command
        case data
        case openedBracket
        case none
    }
    
}



