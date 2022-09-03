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
    
    func makeAuthorizationModule() -> AuthorizationModule {
        return AuthorizationController()
    }
    
}
