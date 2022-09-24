//
//  ChatInformationModule.swift
//  Messenger
//
//  Created by Ivan Pavlov on 21.09.2022.
//

protocol PublicChatInformationModule: BaseModule {
    
    var onBackButton: (() -> Void)? { get set }
    var onLeaveDeleteButton: (() -> Void)? { get set }
    var onDeleteMessagesFromDevice: (() -> Void)? { get set }
    
    func receiveChatMembers(_ chatmembers: [User])
    
}
