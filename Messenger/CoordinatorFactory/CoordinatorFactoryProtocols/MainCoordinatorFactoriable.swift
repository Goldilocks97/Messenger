//
//  MainCoordinatorFactoriable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

protocol MainCoordinatorFactoriable {
    
    func makeMainCoordinator(
        router: Routerable,
        coordinatorFactory: CoordinatorFactoriable,
        user: User
    ) -> Mainable
    
}
