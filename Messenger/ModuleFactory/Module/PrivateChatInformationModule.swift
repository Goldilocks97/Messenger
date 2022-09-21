//
//  PrivateChatInformationModule.swift
//  Messenger
//
//  Created by Ivan Pavlov on 21.09.2022.
//

protocol PrivateChatInformationModule: BaseModule {
    
    var onBackButton: (() -> Void)? { get set }
    var onDeleteMessagesFromDevice: (() -> Void)? { get set }
    var onBlockUser: (() -> Void)? { get set }
    
}
