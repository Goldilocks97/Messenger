//
//  Parser.swift
//  Messenger
//
//  Created by Ivan Pavlov on 05.09.2022.
//

import Foundation

struct Parser {
    
    // MARK: - Current Parsing Command and LexicalAutomate state
    private var command: Command = .none
    private var automateState: AutomateState = .none
    
    // MARK: - LexicalAutomate stuff
    
    private var commandBuffer = String()
    private var messageBuffer = String()
    
    private var buffer = [String]()
    
    // MARK: - API
    
    mutating func parse(data: Data, onCookedData: (Command, String) -> Void) {
        guard let str = String(data: data, encoding: .ascii) else { return }
        for char in str {
            automate(char: char)
            if automateState == .finishedCommand {
                defineCommand()
            }
            if automateState == .finishedMessage {
                onCookedData(command, messageBuffer)
                automateState = .none
                command = .none
            }
        }
    }
    
    // MARK: - LexicalAutomate
    
    mutating private func automate(char: Character) {
        if automateState == .error {
            return
        }
        switch(command) {
        case .none:
            if char == "#" {
                command = .unfull
                return
            }
            return
        case .unfull:
            if char != " " {
                commandBuffer += String(char)
                return
            }
            if char == " " {
                automateState = .finishedCommand
                return
            }
            automateState = .error
        default:
            switch(automateState) {
            case .reading:
                if char == "}" {
                    automateState = .finishedMessage
                    return
                }
                messageBuffer += String(char)
            case .none:
                if char == "{" {
                    automateState = .reading
                }
                return
            default:
                print("I don't know what to do...")
            }
        }
    }
    
    mutating private func defineCommand() {
        switch(commandBuffer) {
        case "auth":
            command = .login
        case "reg":
            command = .reg
        case "chats":
            command = .chats
        default:
            command = .none
        }
        automateState = .none
    }
    
    // MARK: - Constants
    
    private enum ParserConstants {
        
        static let bufferLength = 1024
        
    }
    
    // MARK: - Type of Coomands of Server
        
    private enum AutomateState {
        case reading
        case finishedCommand
        case finishedMessage
        case error
        case none
    }
    
}
