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
    
    func makeContactsModule(systemImage: String, imageColor: UIColor, title: String) -> ContactsModule {
        return ContactsController(systemImage: systemImage, imageColor: imageColor, title: title)
    }
    
    // MARK: - Chats Module
    
    func makeChatsModule(systemImage: String, imageColor: UIColor, title: String) -> ChatsModule {
        return ChatsController(systemImage: systemImage, imageColor: imageColor, title: title)
    }

    // MARK: - Profile Module
    
    func makeProfileModule(systemImage: String, imageColor: UIColor, title: String) -> ProfileModule {
        return ProfileController(systemImage: systemImage, imageColor: imageColor, title: title)
    }
    
    // MARK: - TabBar Module
    
    func makeTabBarModule() -> TabBarModule {
        return TabBarController()
    }
    
}
