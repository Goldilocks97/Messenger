//
//  AuthorizationController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

import UIKit

final class LoginController: UIViewController, LoginModule {
    
    // MARK: - User Data
    
    private var username = ""
    private var password = ""

    // MARK: - AuthorizationModule Implementation
    
    var onLogin: ((String, String) -> Void)?
    var onRegistration: (() -> Void)?
    var onFinishing: ((User) -> Void)?
    
    func loginDidFail() {
        print("failed...Sad...")
        view.backgroundColor = .black
    }
    func loginDidSucces() {
        onFinishing?(User(name: username, password: password))
    }
    
    // MARK: - View Subviews
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        let label = UILabel()
        label.text = "Register."
        label.textColor = .red
        button.addTarget(self, action: #selector(doRegister), for: .touchUpInside)
        button.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            label.topAnchor.constraint(equalTo: button.topAnchor),
            label.bottomAnchor.constraint(equalTo: button.bottomAnchor)])
        return button
    }()
    
    private lazy var newInMessengerLabel: UILabel = {
        let label = UILabel()
        label.text = "New in Messenger?"
        return label
    }()
    
    private lazy var registerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [newInMessengerLabel, registerButton])
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        //stack.backgroundColor = .blue
        return stack
    }()
        
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = .white
        textField.autocorrectionType = .no
        //textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        textField.autocorrectionType = .no
        //textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var loginStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [usernameTextField, passwordTextField])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(doLogin), for: .touchUpInside)
        button.backgroundColor = .red
        return button
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        subscribeToKeyboardNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubviews()
        layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: - Configurate View
    
    private func addSubviews() {
        view.addSubview(loginStack)
        view.addSubview(loginButton)
        view.addSubview(registerStack)
    }
    
    private func layoutSubviews() {
        loginStack.translatesAutoresizingMaskIntoConstraints = false
        registerStack.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/5),
            loginStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/5),
            loginStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loginButton.leadingAnchor.constraint(equalTo: loginStack.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: loginStack.trailingAnchor),
            loginButton.topAnchor.constraint(equalTo: loginStack.bottomAnchor, constant: 10),
            loginButton.heightAnchor.constraint(equalTo: loginStack.heightAnchor, multiplier: 1/3),
        
            registerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            registerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            registerStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            registerStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/10)])
    }

    // MARK: - Buttons actions
    
    @objc private func doLogin() {
        guard
            usernameTextField.hasText,
            passwordTextField.hasText,
            let username = usernameTextField.text,
            let password = passwordTextField.text
        else { return }
        self.username = username
        self.password = password
        onLogin?(username, password)
    }
    
    @objc private func doRegister() {
        onRegistration?()
    }
    
    // MARK : - Keyboard Events
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
    }
}
