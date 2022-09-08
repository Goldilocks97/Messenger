//
//  ModuleFactoriable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

protocol ModuleFactoriable:
    ChatsModuleFactoriable,
    AuthorizationModuleFactoriable,
    RegistrationFactoriable,
    ContactsFactoriable,
    ChatsFactoriable,
    ProfileFactoriable,
    TabBarFactoriable
{}
