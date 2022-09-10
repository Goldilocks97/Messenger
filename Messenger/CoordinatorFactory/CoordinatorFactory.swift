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
        model: Model
    ) -> Mainable {
        return MainCoordinator(
            router: router,
            coordinatorFactory: coordinatorFactory,
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
        moduleFactory: ModuleFactoriable,
        coordinatorFactory: CoordinatorFactoriable,
        rootModule: ChatsModule
    ) -> Chatsable {
        return ChatsCoordinator(
            router: router,
            model: model,
            moduleFactory: moduleFactory,
            coordinatorFactory: coordinatorFactory,
            rootModule: rootModule)
    }
    
    // MARK: - Contacts Coordinator
    
    func makeContactsCoordinator(
        model: Model,
        router: Navigationable,
        moduleFactory: ModuleFactoriable,
        coordinatorFactory: CoordinatorFactoriable,
        rootModule: ContactsModule
    ) -> Contactsable {
        return ContactsCoordinator(
            router: router,
            model: model,
            moduleFactory: moduleFactory,
            coordinatorFactory: coordinatorFactory,
            rootModule: rootModule)
    }
    
    // MARK: - Profile Coordinator
    
    func makeProfileCoordinator(
        model: Model,
        router: Navigationable,
        moduleFactory: ModuleFactoriable,
        coordinatorFactory: CoordinatorFactoriable,
        rootModule: ProfileModule
    ) -> Profiliable {
        return ProfileCoordinator(
            router: router,
            model: model,
            moduleFactory: moduleFactory,
            coordinatorFactory: coordinatorFactory,
            rootModule: rootModule)
    }
    
}
