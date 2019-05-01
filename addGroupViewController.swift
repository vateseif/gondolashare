//
//  addGroupViewController.swift
//  GondolaShare
//
//  Created by SEIF EL FREJ ISMAIL on 28/04/2019.
//  Copyright © 2019 SEIF EL FREJ ISMAIL. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase



class addGroupViewController: UINavigationController {

    
    
    let returnButton : UIButton={
        let but = UIButton(type: .system)
        
        but.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        but.setTitle("Return", for: .normal)
        but.setTitleColor(UIColor.blue, for: .normal)
        but.translatesAutoresizingMaskIntoConstraints = false
        
        return but
    }()
    
    let barButton : UIBarButtonItem = {
        let b = UIBarButtonItem(title: "Return", style: .plain, target: self, action: #selector(reti))
        return b
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.red
        
        navigationItem.leftItemsSupplementBackButton=true
        navigationItem.leftBarButtonItem = barButton
        //buttonSetter()
        
    }



    
    
    func buttonSetter(){
        view.addSubview(returnButton)
        returnButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive=true
        returnButton.heightAnchor.constraint(equalToConstant: 50).isActive=true
        returnButton.widthAnchor.constraint(equalToConstant: 80).isActive=true
        returnButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive=true
        returnButton.addTarget(self, action: #selector(reti), for: .touchUpInside)
    }

    @ objc func reti(){
        self.dismiss(animated: true, completion: nil)
    }


}
