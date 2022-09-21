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
    let router: Routerable
    let moduleFactory: ModuleFactoriable
    let coordinatorFactory: CoordinatorFactoriable
    let rootModule: ChatsModule
    
    private var chatModules = [ChatModule]()
    
    // MARK: - Initialization
    
    init(
        router: Routerable,
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
            self?.rootModule.receiveLastMessage(LastMessage(
                chatID: message.chatID,
                text: message.text,
                date: message.date, time: message.time))
            if self == nil { return }
            for module in self!.chatModules {
                if module.chatID == message.chatID {
                    module.receiveNewMessages([message])
                    return
                }
            }
        }
        rootModule.onDidSelectChat = { [weak self] (chat) in
            
            // TODO: - Memory leak, I create a new pointer every time user selects a chat

            if let chatModule = self?.moduleFactory.makeChatModule(
                chatName: chat.name,
                chatID: chat.id,
                type: (chat.hostId != -1 ? .publicChat : .privateChat ))
            {
                self?.setupChatModule(chatModule)
                self?.model.messages(for: chat.id) { (messages) in
                    chatModule.receiveNewMessages(messages.value)
                }
                self?.chatModules.append(chatModule)
                self?.router.push(chatModule, animated: true)
            }
        }
        rootModule.onNewChat = { [weak self] in
            if let newChatModule = self?.moduleFactory.makeNewChatModule() {
                self?.router.present(newChatModule, animated: true)
            }
        }
        model.chats() { [weak self] (chats) in
            self?.rootModule.chatsUpdate = chats.value
            for chat in chats.value {
                if chat.lastMessage == nil {
                    self?.model.lastMessage(for: chat.id) { [weak self] (message) in
                        self?.rootModule.receiveLastMessage(message)
                    }
                }
            }
        }
    }
    
    // MARK: - Setup Modules
    
    private func setupChatModule(_ module: ChatModule) {
        module.onSendMessage = { [weak self] (message) in
            self?.rootModule.receiveLastMessage(LastMessage(
                chatID: message.chatID,
                text: message.text,
                date: message.date,
                time: message.time))
            self?.model.sendMessage(message)
        }
        module.onBackPressed = { [weak self] in
            self?.router.pop(animated: true)
        }
        module.onChatInformationPressed = { [weak self] (chatID, type) in
            if type == .privateChat {
                if let privateInformationModule =
                    self?.moduleFactory.makePrivateChatInformationModule()
                {
                    privateInformationModule.onBackButton = { [weak self] in
                        self?.router.pop(animated: true)
                    }
                    self?.router.push(privateInformationModule, animated: true)
                }
            } else if let publicInformationModule = self?.moduleFactory.makePublicChatInformationModule() {
                publicInformationModule.onBackButton = { [weak self] in
                    self?.router.pop(animated: true)
                }
                self?.router.push(publicInformationModule, animated: true)
            }
        }
    }
    
}



