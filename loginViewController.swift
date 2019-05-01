//
//  loginViewController.swift
//  GondolaShare
//
//  Created by SEIF EL FREJ ISMAIL on 15/04/2019.
//  Copyright © 2019 SEIF EL FREJ ISMAIL. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class loginViewController: UIViewController {

    
    let gonshareLabel : UILabel = {
        let lab = UILabel()
        
        
        return lab
    }()
    
    let gonshareLogo : UIImageView = {
        let im = UIImageView()
        return im
    }()
    
    
    let descriptionLabel : UILabel = {
        let lab = UILabel()
        
        
        return lab
    }()
    
    
    
    let loginWithNumber : UIButton = {
        let but = UIButton(type: .roundedRect)
        
        return but
    }()
    
    
    
    let loginWithFacebook : UIButton = {
        let but = UIButton(type: .roundedRect)
        
        return but
    }()
    
    
    
    
    
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var loginRegisterBar : UISegmentedControl={
        let bar = UISegmentedControl()
        bar.insertSegment(withTitle: "Login", at: 0, animated: true)
        bar.insertSegment(withTitle: "Register", at: 1, animated: true)
        bar.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        bar.tintColor = UIColor.lightGray
        bar.selectedSegmentIndex = 0
        bar.translatesAutoresizingMaskIntoConstraints = false
        
        //Changing Register and Login settings
        bar.addTarget(self, action: #selector(switchSelected), for: .valueChanged)
        
        return bar
    }()
    
    let returnButton : UIButton={
        let but = UIButton(type: .system)
        
        but.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        but.setTitle("Return", for: .normal)
        but.setTitleColor(UIColor.blue, for: .normal)
        but.translatesAutoresizingMaskIntoConstraints = false
        
        return but
    }()
    
    @objc func switchSelected(){
        
        inputContainerViewHeightConstraint?.constant = loginRegisterBar.selectedSegmentIndex == 0 ? 120 : 180
        separator2Constraint?.constant = loginRegisterBar.selectedSegmentIndex == 0 ? 0 : 1
        
        let title = loginRegisterBar.selectedSegmentIndex == 0 ? "Login" : "Register"
        registerButton.setTitle(title, for: .normal)
        
        passwordConstraint?.isActive=false
        passwordConstraint = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterBar.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordConstraint?.isActive=true
        
        emailConstraint?.isActive=false
        emailConstraint = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterBar.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailConstraint?.isActive=true
        
        
        nameConstraint?.isActive=false
        nameConstraint = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterBar.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameConstraint?.isActive=true
        
    }
    
    @objc func ret(){
        let view = ViewController()
        present(view,animated: true,completion: nil)
    }
    
    let separatorView1 : UIView = {
        let sep = UIView()
        sep.backgroundColor = UIColor.lightGray
        return sep
    }()
    
    let separatorView2 : UIView = {
        let sep = UIView()
        sep.backgroundColor = UIColor.white
        sep.tintColor = UIColor.white
        return sep
    }()
    
    let nameTextField : UITextField={
        let name = UITextField()
        name.placeholder = "Name"
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = UIColor.lightGray
        
        return name
    }()
    
    let emailTextField : UITextField={
        let name = UITextField()
        name.placeholder = "Email"
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = UIColor.lightGray
        
        return name
    }()
    
    let passwordTextField : UITextField={
        let name = UITextField()
        name.placeholder = "Password"
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = UIColor.lightGray
        
        return name
    }()
    
    let separatotr1 : UIView = {
        let sep = UIView()
        sep.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        sep.translatesAutoresizingMaskIntoConstraints=false
        
        return sep
    }()
    
    let separatotr2 : UIView = {
        let sep = UIView()
        sep.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        sep.translatesAutoresizingMaskIntoConstraints=false
        
        return sep
    }()
    
    
    
    let registerButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.darkGray
        button.layer.cornerRadius = 5
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        return button
    }()
    
    
    let inputContainerView : UIView={
        let container = UIView()
        container.backgroundColor = UIColor.darkGray
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 5
        
        return container
        
    }()
    
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        
        view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        
        //returnButton.addTarget(self, action: #selector(ret), for: .touchUpInside)
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterBar)
        view.addSubview(registerButton)
        view.addSubview(passwordTextField)
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(separatotr1)
        view.addSubview(separatotr2)
        view.addSubview(returnButton)
        
        
        hideKeyboardWhenTappedAround()
        
        
        
        
        containerLoginSetter()
        BarSetter()
        buttonSetter()
        handleConstraint()
        
        returnButton.addTarget(self, action: #selector(reti), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    @ objc func handleRegister(){
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("format is not valid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            ref = Database.database().reference(fromURL: "https://gonshare-72766.firebaseio.com/")
            
            if error != nil {print(error!, "error");return}
            
            guard let identifier = user?.user.uid else {return}
            
            uid = identifier
            ref.child("Users/\(uid)").setValue(["name" : name, "email" : email])
            self.dismiss(animated: true, completion: nil)
            
        })
        
    }
    
    
    
    
    
    func BarSetter(){
        loginRegisterBar.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -20).isActive=true
        loginRegisterBar.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -3).isActive=true
        loginRegisterBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier:1/21).isActive=true
        loginRegisterBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        returnButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive=true
        returnButton.heightAnchor.constraint(equalToConstant: 50).isActive=true
        returnButton.widthAnchor.constraint(equalToConstant: 80).isActive=true
        returnButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive=true
        
    }
    
    
    var inputContainerViewHeightConstraint : NSLayoutConstraint?
    
    func containerLoginSetter(){
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive=true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.2).isActive=true
        inputContainerViewHeightConstraint = inputContainerView.heightAnchor.constraint(equalToConstant: 100)
        inputContainerViewHeightConstraint?.isActive=true
    }
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    func buttonSetter() {
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        registerButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -3).isActive=true
        registerButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier:1/21).isActive=true
        registerButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 20).isActive=true
    }
    
    var passwordConstraint : NSLayoutConstraint?
    var nameConstraint : NSLayoutConstraint?
    var emailConstraint : NSLayoutConstraint?
    var separator2Constraint : NSLayoutConstraint?
    
    func handleConstraint(){
        passwordConstraint = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/2)
        passwordConstraint?.isActive=true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
        passwordTextField.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor).isActive=true
        passwordTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor, constant: 3).isActive=true
        
        nameConstraint = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0)
        nameConstraint?.isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: 2).isActive=true
        nameTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor, constant: 3).isActive=true
        
        emailConstraint = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/2)
        emailConstraint?.isActive=true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
        emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor).isActive=true
        emailTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor, constant: 3).isActive=true
        
        separatotr1.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
        separatotr1.heightAnchor.constraint(equalToConstant: 1).isActive=true
        separatotr1.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive=true
        separatotr1.topAnchor.constraint(equalTo: passwordTextField.topAnchor).isActive=true
        
        separatotr2.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
        separator2Constraint = separatotr2.heightAnchor.constraint(equalToConstant: 0)
        separator2Constraint?.isActive=true
        separatotr2.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive=true
        separatotr2.topAnchor.constraint(equalTo: emailTextField.topAnchor).isActive=true
        
        
        
        
    }
    
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    
    func buttoniSetter(){
        returnButton.frame = CGRect(x: 200, y: 300, width: 150, height: 50)
    }
    
    @ objc func reti(){
        self.dismiss(animated: true, completion: nil)
        
    }
    
}



extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
