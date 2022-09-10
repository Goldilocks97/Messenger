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
    
    // MARK: - CallBack
    
    var onCookedData: ((String, String) -> Void)?

    // MARK: - API

    mutating func parse(data: Data) {
        guard let str = String(data: data, encoding: .ascii) else { return }
        for char in str {
            automate(char: char)
            if state == .finished {
                state = .none
                onCookedData?(String(commandBuffer), String(dataBuffer))
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
            commandBuffer.append(char)
        case .data:
            if char == "\n" {
                state = .finished
                return
            }
            dataBuffer.append(char)
        default:
            print("I don't know what to do...")
        }
    }

    // TODO: - Restrict length of buffers
    
    private enum ParserConstants {
        
        static let bufferLength = 1024
        
    }

    // MARK: - Automate States
        
    private enum AutomateState {
        case finished
        case command
        case data
        case none
    }
    
}
