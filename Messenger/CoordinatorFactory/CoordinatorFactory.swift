//
//  File.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

final class CoordinatorFactory: CoordinatorFactoriable {
    
    // MARK: - Main Coordinator
    
    func makeMainCoordinator(router: Routerable, coordinatorFactory: CoordinatorFactoriable) -> Coordinatorable {
        return MainCoordinator(router: router, coordinatorFactory: coordinatorFactory)
    }
    
    // MARK: - Authorization Coordinator
    
    func makeAuthorizationCoordinator(router: Routerable) -> Coordinatorable {
        return AuthorizationCoordinator(router: router)
    }
    
}
