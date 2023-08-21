//
//  MainViewController.swift
//  MVVM_Combine_login_password
//
//  Created by Aleksey Alyonin on 21.08.2023.
//

import UIKit
import Combine

class MainViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel = MainViewModel()
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindingViewModel()
        initialButton()
    }

    @IBAction func buttonAction(_ sender: Any) {
        viewModel.submitLogin()
    }
    
    func initialButton(){
        self.statusText.isHidden = true
        self.statusText.text = ""
        self.statusText.textColor = .darkGray
        self.loginButton.backgroundColor = .orange.withAlphaComponent(0.4)
    }
    
    func bindingViewModel(){
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: loginTextField)
            .map { ($0.object as! UITextField).text ?? "" }
            .assign(to: \.login, on: viewModel)
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: passwordTextField)
            .map { ($0.object as! UITextField).text ?? "" }
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
        
        viewModel.isLoginEnable
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &cancellables)
        
        viewModel.$state
            .sink { [weak self] state in
                switch state {
                case .failed:
                    self?.statusText.isHidden = false
                    self?.statusText.text = "Login failed =("
                    self?.statusText.textColor = .systemRed
                    self?.loginButton.setTitle("Login", for: .normal)
                case .success:
                    self?.statusText.isHidden = false
                    self?.statusText.text = "Login success!"
                    self?.statusText.textColor = .systemGreen
                    self?.loginButton.setTitle("Login", for: .normal)
                    self?.loginButton.backgroundColor = .orange
                case .loading:
                    self?.statusText.isHidden = true
                    self?.loginButton.isEnabled = false
                    self?.loginButton.setTitle("Loading..", for: .normal)
                case .none:
                    break
                }
            }.store(in: &cancellables)
    }
    
}
