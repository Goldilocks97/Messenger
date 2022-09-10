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
    
}
