//
//  ChatModule.swift
//  Messenger
//
//  Created by Ivan Pavlov on 10.09.2022.
//

protocol ChatModule: BaseModule {
    
    var onSendMessage: ((Message) -> Void)? { get set }
    var messagesUpdate: [Message] { get set }
    var chatID: Int { get set }
    
}
