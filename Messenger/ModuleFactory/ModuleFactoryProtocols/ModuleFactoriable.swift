//
//  ModuleFactoriable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

protocol ModuleFactoriable:
    DialogsModuleFactoriable,
    AuthorizationModuleFactoriable,
    RegistrationFactoriable,
    ContactsFactoriable,
    DialogsFactoriable,
    ProfileFactoriable
{}
