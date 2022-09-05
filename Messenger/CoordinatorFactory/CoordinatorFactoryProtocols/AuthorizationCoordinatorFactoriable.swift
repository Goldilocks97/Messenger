//
//  AuthorizationCoordinatorFactoriable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

protocol AuthorizationCoordinatorFactoriable {
    
    func makeAuthorizationCoordinator(router: Routerable, model: Model) -> Authorizationable
    
}
