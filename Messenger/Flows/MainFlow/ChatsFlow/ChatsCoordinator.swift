//
//  ChatsCoordinator.swift
//  Messenger
//
//  Created by Ivan Pavlov on 09.09.2022.
//

import UIKit

final class ChatsCoordinator: BaseCoordinator, Chatsable {
    
    // MARK: - Private properties
    
    let model: Model
    let router: Navigationable
    let moduleFactory: ModuleFactoriable
    let coordinatorFactory: CoordinatorFactoriable
    let rootModule: ChatsModule
    
    private var chatModules = [ChatModule]()
    
    // MARK: - Initialization
    
    init(
        router: Navigationable,
        model: Model,
        moduleFactory: ModuleFactoriable,
        coordinatorFactory: CoordinatorFactoriable,
        rootModule: ChatsModule)
    {
        self.router = router
        self.model = model
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
        self.rootModule = rootModule
    }

    // MARK: - Coordinatorable Implementation

    override func start() {
        model.onDidReceiveMessage = { [weak self] (message) in
            if self == nil { return }
            for module in self!.chatModules {
                if module.chatID == message.chatID {
                    module.messagesUpdate = [message]
                    return
                }
            }
        }
        rootModule.onDidSelectChat = { [weak self] (chat) in
            if let chatModule = self?.moduleFactory.makeChatModule(chatName: chat.name, chatID: chat.id) {
                self?.setupChatModule(chatModule)
                self?.model.messages(for: chat.id) { (messages) in
                    chatModule.messagesUpdate = messages.value
                }
                self?.chatModules.append(chatModule)
                self?.router.push(chatModule, animated: true)
            }
        }
        model.chats() { [weak self] (chats) in
            self?.rootModule.chatsUpdate = chats.value
        }
    }
    
    // MARK: - Setup Modules
    
    private func setupChatModule(_ module: ChatModule) {
        module.onSendMessage = { [weak self] (message) in
            self?.model.sendMessage(message)
        }
    }
    
}
