//
//  MainViewModel.swift
//  MVVM_Combine_login_password
//
//  Created by Aleksey Alyonin on 21.08.2023.
//

import UIKit
import Combine

enum ViewState {
    case failed
    case success
    case loading
    case none
}

class MainViewModel {
    @Published var login = ""
    @Published var password = ""
    @Published var state = ViewState.none
    
    var isFailedUserNamePublisher: AnyPublisher<Bool,Never> {
        $login
            .map{ $0.isEmail() }
            .eraseToAnyPublisher()
    }
    
    var isFailedPasswordPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    var isLoginEnable: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isFailedUserNamePublisher, isFailedPasswordPublisher)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    
    func isCorrectLogin() -> Bool {
        return login == "test@mail.ru" && password == "12345"
    }
    
    func submitLogin(){
        state = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {[weak self] in
            guard let self = self else { return }
            if self.isCorrectLogin() {
                self.state = .success
            } else {
                self.state = .failed
            }
        }
    }
}
