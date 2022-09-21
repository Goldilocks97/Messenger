//
//  ChatModule.swift
//  Messenger
//
//  Created by Ivan Pavlov on 10.09.2022.
//

protocol ChatModule: BaseModule {
    
    var onSendMessage: ((Message) -> Void)? { get set }
    var onBackPressed: (() -> Void)? { get set }
    var onChatInformationPressed: ((Int, ChatType) -> Void)? { get set }
    var chatID: Int { get set }
    
    func receiveNewMessages(_ messages: [Message])
    
}
