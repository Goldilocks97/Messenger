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
    
    // MARK: - Contacts Module
    
    func makeContactsModule() -> ContactsModule {
        return ContactsController()
    }
    
    // MARK: - Chats Module
    
    func makeChatsModule() -> ChatsModule {
        return ChatsController()
    }

    // MARK: - Profile Module
    
    func makeProfileModule() -> ProfileModule {
        return ProfileController()
    }
    
    // MARK: - TabBar Module
    
    func makeTabBarModule() -> TabBarModule {
        return TabBarController()
    }
    
}
