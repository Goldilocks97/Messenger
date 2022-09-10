//
//  File.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

final class CoordinatorFactory: CoordinatorFactoriable {
    
    // MARK: - Main Coordinator
    
    func makeMainCoordinator(
        router: Routerable,
        coordinatorFactory: CoordinatorFactoriable,
        moduleFactory: ModuleFactoriable,
        model: Model
    ) -> Mainable {
        return MainCoordinator(
            router: router,
            coordinatorFactory: coordinatorFactory,
            moduleFactory: moduleFactory,
            model: model)
    }
    
    // MARK: - Authorization Coordinator
    
    func makeAuthorizationCoordinator(router: Routerable, model: Model) -> Authorizationable {
        return AuthorizationCoordinator(router: router, model: model)
    }
    
    // MARK: - Chats Coordinator
    
    func makeChatsCoordinator(
        model: Model,
        router: Navigationable,
        moduleFactory: ModuleFactoriable
    ) -> Chatsable {
        return ChatsCoordinator(model: model, router: router, moduleFactory: moduleFactory)
    }
    
    // MARK: - Contacts Coordinator
    
    func makeContactsCoordinator(
        model: Model,
        router: Navigationable,
        moduleFactory: ModuleFactoriable
    ) -> Contactsable {
        return ContactsCoordinator(model: model, router: router, moduleFactory: moduleFactory)
    }
    
    // MARK: - Profile Coordinator
    
    func makeProfileCoordinator(
        model: Model,
        router: Navigationable,
        moduleFactory: ModuleFactoriable
    ) -> Profiliable {
        return ProfileCoordinator(model: model, router: router, moduleFactory: moduleFactory)
    }
    
}
