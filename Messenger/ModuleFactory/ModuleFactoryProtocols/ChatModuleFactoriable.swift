//
//  ChatModuleFactoriable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 10.09.2022.
//

protocol ChatModuleFactoriable {
    
    func makeChatModule(chatName: String, chatID: Int, type: ChatType) -> ChatModule
    
}
