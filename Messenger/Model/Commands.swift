//
//  Commands.swift
//  Messenger
//
//  Created by Ivan Pavlov on 05.09.2022.
//

enum Command {
    case none                  // A command has been just parsed so there is no current command
    case unfull                // A command is being reading right know
    case login
    case chats
    case reg
}

