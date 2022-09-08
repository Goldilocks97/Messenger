//
//  RegistrationController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 05.09.2022.
//

import UIKit

final class RegistrationController: UIViewController, RegistrationModule {
    
    // MARK: - RegistrationModule Implementation
    
    var onFinishing: ((User) -> Void)? // we don't need to return user cause we have it in coordinator
    var onRegistration: ((String, String, String) -> Void)?
    var onBackPressed: (() -> Void)?
    
    // MARK: - View Subviews
    
    private lazy var nameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "How other users see you"
        field.backgroundColor = .white
        field.autocorrectionType = .no
        return field
    }()
    
    private lazy var usernameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username"
        field.backgroundColor = .white
        field.autocorrectionType = .no
        return field
    }()
    
    private lazy var passwordTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.backgroundColor = .white
        field.autocorrectionType = .no
        return field
    }()
    
    private lazy var registrationStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameTextField, usernameTextField, passwordTextField])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var registrateButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(doRegistrate), for: .touchUpInside)
        button.backgroundColor = .red
        return button
    }()
    
    private lazy var backBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(doBackButton))
        button.tintColor = .red
        return button
    }()
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addSubviews()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Registration"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: - Configurate View
    
    private func addSubviews() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backBarButton
        view.addSubview(registrationStack)
        view.addSubview(registrateButton)
    }
    
    private func setupSubviews() {
        registrationStack.translatesAutoresizingMaskIntoConstraints = false
        registrateButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            registrationStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/5),
            registrationStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/5),
            registrationStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registrationStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        
            registrateButton.leadingAnchor.constraint(equalTo: registrationStack.leadingAnchor),
            registrateButton.trailingAnchor.constraint(equalTo: registrationStack.trailingAnchor),
            registrateButton.topAnchor.constraint(equalTo: registrationStack.bottomAnchor, constant: 10),
            registrateButton.heightAnchor.constraint(equalTo: registrationStack.heightAnchor, multiplier: 1/3)])
    }
    
    // MARK: - Buttons actions
    
    @objc private func doRegistrate() {
        guard
            let name = nameTextField.text,
            let username = usernameTextField.text,
            let password = passwordTextField.text
        else { return }
        onRegistration?(name, username, password)
    }
    
    @objc private func doBackButton() {
        onBackPressed?()
    }
    
}
