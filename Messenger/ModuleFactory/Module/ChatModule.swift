//
//  ChatModule.swift
//  Messenger
//
//  Created by Ivan Pavlov on 10.09.2022.
//

protocol ChatModule: BaseModule {
    
    var onSendMessage: ((String) -> Void)? { get set }
    
}
