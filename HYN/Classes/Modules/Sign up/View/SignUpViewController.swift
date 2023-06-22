//
//  SignUpViewController.swift
//  HYN
//
//  Created by Hadia Yehia on 10/06/2023.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    let defaults = UserDefaults.standard
    @IBOutlet weak var confirmPassTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    var customer : CustomerRequest?
    let viewModel = SignUpViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setFieldsStyle()
        //bindViewModel()
        // Do any additional setup after loading the view.
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    func setFieldsStyle()
    {
        confirmPassTF.setBoarder()
        passwordTF.setBoarder()
        emailTF.setBoarder()
        phoneTF.setBoarder()
        lastNameTF.setBoarder()
        firstNameTF.setBoarder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func skipBtn(_ sender: UIButton) {
        let homeVC = TabBar()
        navigationController?.pushViewController(homeVC, animated: true)

    }
    @IBAction func signUpBtn(_ sender: UIButton) {
        guard let firstName = firstNameTF.text, let lastName = lastNameTF.text, let phone = phoneTF.text , let email = emailTF.text , let password = passwordTF.text , let confirmPassword = confirmPassTF.text else{
            Toast.show(message: "All fields must be filled", controller: self)
            return
        }
            if password == confirmPassword{
                let customer = Customer(first_name: firstName, last_name: lastName, email: email, phone: phone, verified_email: false, password: password, password_confirmation: confirmPassword, send_email_welcome: true)
                self.viewModel.rigesterNewCustomer(customer: customer,completionHandler: {
                    result in
                    switch result{
                    case .success(_):
                        self.defaults.setValue(true, forKey: "logged in")
                        print(self.defaults.bool(forKey: "logged in"))
                        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
                        self.navigationController?.pushViewController(loginVC, animated: true)
                        break
                    case .failure(let error):
                        print("signup error\(error.localizedDescription)")
                        Toast.show(message: error.localizedDescription, controller: self)
                        break
                    }
                })
//                self.viewModel.isLoading.bind{[weak self] isLoading in
//                    guard let self = self , let isLoading = isLoading
//                    else{return}
//
//                    DispatchQueue.main.async {
//                        if isLoading{
//
//                        }else{
//
//
//                        }
//                    }
//                }
            }else{
                Toast.show(message: "Password doesn't match", controller: self)
            }
           
        
    }
    
    @IBAction func signInBtn(_ sender: UIButton) {
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        navigationController?.pushViewController(loginVC, animated: true)
    }
 
}
