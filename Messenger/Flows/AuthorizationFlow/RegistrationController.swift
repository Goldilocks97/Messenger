//
//  RegistrationController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 05.09.2022.
//

import UIKit

final class RegistrationController: UIViewController, RegistrationModule {
    
    // MARK: - RegistrationModule Implementation
    
    var onFinishing: ((User) -> Void)?
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
    
    
}
