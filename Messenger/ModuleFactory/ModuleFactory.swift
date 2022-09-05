//
//  ModuleFactory.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

final class ModuleFactory: ModuleFactoriable {
        
    // MARK: - Dialogs Module
    
    func makeDialogsModule() -> DialogsModule {
        return DialogsController()
    }
    
    // MARK: - Authorization Module
    
    func makeAuthorizationModule() -> LoginModule {
        return LoginController()
    }
    
    // MARK: - Registration Module
    
    func makeRegistrationModule() -> RegistrationModule {
        return RegistrationController()
    }
    
}
