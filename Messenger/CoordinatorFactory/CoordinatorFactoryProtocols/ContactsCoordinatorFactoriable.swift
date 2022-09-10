//
//  ContactsCoordinatorFactoriable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 09.09.2022.
//

protocol ContactsCoordinatorFactoriable {
    
    func makeContactsCoordinator(
        model: Model,
        router: Navigationable,
        moduleFactory: ModuleFactoriable,
        coordinatorFactory: CoordinatorFactoriable,
        rootModule: ContactsModule
    ) -> Contactsable
    
}
