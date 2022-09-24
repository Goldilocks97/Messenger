//
//  ChatsTableModule.swift
//  Messenger
//
//  Created by Ivan Pavlov on 10.09.2022.
//

protocol ChatsModule: TabBarableBaseModule {
    
    var onDidSelectedChat: ((Chat) -> Void)? { get set}
    var onNewChatPressed: (() -> Void)? { get set }
    
    func receiveLastMessage(_ message: LastMessage)
    func receiveNewChats(_ chats: [Chat])
}
