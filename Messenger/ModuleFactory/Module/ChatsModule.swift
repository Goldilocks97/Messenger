//
//  ChatsTableModule.swift
//  Messenger
//
//  Created by Ivan Pavlov on 10.09.2022.
//

protocol ChatsModule: TabBarableBaseModule {
    
    var onDidSelectChat: ((Chat) -> Void)? { get set}
    var chatsUpdate: [Chat] { get set }
    
}
