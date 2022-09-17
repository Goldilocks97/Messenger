//
//  ModuleFactory.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

import UIKit

final class ModuleFactory: ModuleFactoriable {

    // MARK: - Authorization Module
    
    func makeAuthorizationModule() -> LoginModule {
        return LoginController()
    }
    
    // MARK: - Registration Module
    
    func makeRegistrationModule() -> RegistrationModule {
        return RegistrationController()
    }
    
    // MARK: - Chats Module

    func makeChatsModule() -> ChatsModule {
        return ChatsTableController()
    }

    // MARK: - Profile Module

    func makeProfileModule() -> ProfileModule {
        return ProfileTableController()
    }
    
    // MARK: - TabBar Module
    
    func makeTabBarModule(tabs: [TabBarableBaseModule]) -> TabBarModule {
        return TabBarController(tabs: tabs)
    }

    // MARK: - Chat Module
    
    func makeChatModule(chatName: String, chatID: Int) -> ChatModule {
        return ChatController(chatName: chatName, chatID: chatID)
    }
    
}
