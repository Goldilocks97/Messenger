//
//  ModuleFactoriable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

protocol ModuleFactoriable:
    AuthorizationModuleFactoriable,
    RegistrationModuleFactoriable,
    TabBarModuleFactoriable,
    ChatsModuleFactoriable,
    ProfileModuleFactoriable,
    ChatModuleFactoriable,
    NewChatModuleFactoriable,
    PublicChatInformationModuleFactoriable,
    PrivateChatInformationModuleFactoriable,
    PrivacyAndSecurityModuleFactoriable,
    StorageModuleFactoriable,
    AppearanceModuleFactoriable,
    AskQuestionModuleFactoriable,
    BlockedUsersModuleFactoriable,
    ChangePasswordModuleFactoriable,
    PasswordOnLoginModuleFactoriable,
    LogoutModuleFactoriable
{}
