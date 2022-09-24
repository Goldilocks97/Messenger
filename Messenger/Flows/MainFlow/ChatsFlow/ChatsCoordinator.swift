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
    
    
    // TODO: - Cache is better.

    private var chatModules = [Int: ChatModule]()
    
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
        super.init()
        
        model.onReceivedMessages = { [weak self] (messages) in
            self?.modelDidReceivedMessages(messages)
        }
        model.onReceivedChats = { [weak self] (chats) in
            self?.modelDidReceivedChats(chats)
        }
    }

    // MARK: - Coordinatorable Implementation

    override func start() {
        rootModule.onDidSelectedChat = { [weak self] (chat) in
            self?.userDidSelectedChat(chat)
        }
        rootModule.onNewChatPressed = { [weak self] in
            self?.userDidPressedNewChatButton()
        }
        model.chats()
    }
    
    // MARK: - Callbacks for Modules
    
    private func modelDidReceivedChats(_ chats: [Chat]) {
        rootModule.receiveNewChats(chats)
        chats.forEach(where: { $0.lastMessage == nil }) {
            model.lastMessage(for: $0.id) { [weak self] (message) in
                self?.rootModule.receiveLastMessage(message)
            }
        }
    }

    private func modelDidReceivedMessages(_ messages: [Message]) {
        if let chatID = messages.first?.chatID {
            chatModules[chatID]?.receiveNewMessages(messages)
            if let last = messages.last {
                rootModule.receiveLastMessage(last.transformIntoLastMessage())
            }
        }
    }

    private func userDidPressedNewChatButton() {
        let newChatModule = moduleFactory.makeNewChatModule()
        setupNewChatModule(newChatModule)
        router.present(newChatModule, animated: true)
    }
    
    private func userDidSelectedChat(_ chat: Chat) {
        var chatModule: ChatModule
        if let module = chatModules[chat.id] {
            chatModule = module

        } else {
            let type: ChatType = chat.hostId != -1 ? .publicChat : .privateChat
            chatModule = moduleFactory.makeChatModule(name: chat.name, ID: chat.id, type: type)
            chatModules[chat.id] = chatModule
            setupChatModule(chatModule)
            model.messages(for: chat.id)
        }
        router.push(chatModule, animated: true)
    }
    
    private func userDidPressedInformationButton(in chatID: Int, of type: ChatType) {
        switch(type) {
        case .privateChat:
            let privateInformationModule = moduleFactory.makePrivateChatInformationModule()
            setupPrivateChatInformationModule(privateInformationModule)
            router.push(privateInformationModule, animated: true)
        case .publicChat:
            let publicInformationModule = moduleFactory.makePublicChatInformationModule()
            setupPublicChatInformationModule(publicInformationModule)
            model.chatMembers(of: chatID) { (users) in
                publicInformationModule.receiveChatMembers(users.value)
            }
            router.push(publicInformationModule, animated: true)
        }
    }
    
    // MARK: - Setup Modules
    
    private func setupNewChatModule(_ module: NewChatModule) {
        module.onCreatePrivateChat = { [weak self] (user) in
            self?.model.createPrivateChat(with: user)
        }
        module.onCreatePublicChat = { [weak self] (name, users) in
            self?.model.createPublicChat(with: users, name: name)
        }
        module.onFindUser = { [weak self] (nickname) in
            self?.model.findUserID(with: nickname) { (response) in
                module.userSearchResponse(response: response)
            }
        }
    }
    
    private func setupChatModule(_ module: ChatModule) {
        module.onSendMessage = { [weak self] (text, chatID) in
            self?.model.sendMessage(text: text, chatID: chatID)
        }
        module.onBackPressed = { [weak self] in
            self?.router.pop(animated: true)
        }
        module.onChatInformationPressed = { [weak self] (chatID, type) in
            self?.userDidPressedInformationButton(in: chatID, of: type)
        }
    }
    
    private func setupPrivateChatInformationModule(_ module: PrivateChatInformationModule) {
        module.onBackButton = { [weak self] in
            self?.router.pop(animated: true)
        }
    }
    
    private func setupPublicChatInformationModule(_ module: PublicChatInformationModule) {
        module.onBackButton = { [weak self] in
            self?.router.pop(animated: true)
        }
    }
}

// MARK: - Extensions

extension Array {
    
    func forEach(where condition: (Element) -> Bool, do action: (Element) -> Void) {
        for element in self {
            if condition(element) {
                action(element)
            }
        }
    }
    
}

