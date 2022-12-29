//
//  ViewController.swift
//  LoginRxSwift
//
//  Created by jennifersoft_th on 28/12/2565 BE.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private let loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.becomeFirstResponder()
        
        emailTextField.rx.text.map{ $0 ?? "" }.bind(to: loginViewModel.emailTextPublishSubject).disposed(by: disposeBag)
        passTextField.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.passTextPublishSubject).disposed(by: disposeBag)
        
        loginViewModel.isValid().bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        
        loginViewModel.isValid().map{ $0 ? 1 : 0.1 }.bind(to: loginButton.rx.alpha).disposed(by: disposeBag)
        
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
    }

    @objc func tappedLoginButton(_ sender: UIButton){
        print("tapped login button")
    }

}

class LoginViewModel {
    let emailTextPublishSubject = PublishSubject<String>()
    let passTextPublishSubject = PublishSubject<String>()
     
    func isValid() -> Observable<Bool> {
        Observable.combineLatest(emailTextPublishSubject.asObservable(), passTextPublishSubject.asObservable()).map { email ,pass in
            return email.count > 3 && pass.count > 3
        }.startWith(false)
    }
    
    
}
