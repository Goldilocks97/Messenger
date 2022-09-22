//
//  ProfileCoordinatorFactoriable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 09.09.2022.
//

protocol ProfileCoordinatorFactoriable {
    
    func makeProfileCoordinator(
        model: Model,
        router: Routerable,
        moduleFactory: ModuleFactoriable,
        coordinatorFactory: CoordinatorFactoriable,
        rootModule: ProfileModule
    ) -> Profiliable
    
}
