//
//  ChatsCoordinatorFactoriable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 09.09.2022.
//

protocol ChatsCoordinatorFactoriable {
    
    func makeChatsCoordinator(
        model: Model,
        router: Navigationable,
        moduleFactory: ModuleFactoriable
    ) -> Chatsable
    
}
