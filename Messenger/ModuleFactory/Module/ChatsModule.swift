//
//  ChatsTableModule.swift
//  Messenger
//
//  Created by Ivan Pavlov on 10.09.2022.
//

protocol ChatsModule: TabBarableBaseModule {
    
    var onDidSelectedChat: ((Chat) -> Void)? { get set}
    var onNewChat: (() -> Void)? { get set }
    var chatsUpdate: [Chat] { get set }
    
    func receiveLastMessage(_ message: LastMessage)
    
}
