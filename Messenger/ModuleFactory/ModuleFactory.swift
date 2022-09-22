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
    
    func makeChatModule(chatName: String, chatID: Int, type: ChatType) -> ChatModule {
        return ChatController(chatName: chatName, chatID: chatID, type: type)
    }
    
    // MARK: - NewChat Module
    
    func makeNewChatModule() -> NewChatModule {
        return NewChatController()
    }
    
    // MARK: - PublicChatInformation Module
    
    func makePublicChatInformationModule() -> PublicChatInformationModule {
        return PublicChatInformationController()
    }
    
    // MARK: - PrivateChatInformation Module
    
    func makePrivateChatInformationModule() -> PrivateChatInformationModule {
        return PrivateChatInformationController()
    }
    
    // MARK: - PrivacyAndSecurity Module
    
    func makePrivacyAndSecurityModule() -> PrivacyAndSecurityModule {
        return PrivacyAndSecurityController()
    }

    // MARK: - Storage Module
    
    func makeStorageModule() -> StorageModule {
        return StorageController()
    }

    // MARK: - Appearance Module

    func makeAppearanceModule() -> AppearanceModule {
        return AppearanceController()
    }

    // MARK: - AskQuestion Module

    func makeAskQuestionModule() -> AskQuestionModule {
        return AskQuestionController()
    }

}
