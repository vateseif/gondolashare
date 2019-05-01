//
//  PullUpSheetViewController.swift
//  GondolaShare
//
//  Created by SEIF EL FREJ ISMAIL on 26/03/2019.
//  Copyright © 2019 SEIF EL FREJ ISMAIL. All rights reserved.
//

import UIKit

class PullUpSheetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    let upperBandView : UIView = {
       
        let v = UIView()
        v.backgroundColor = UIColor.blue
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    let bottonBandView : UIView = {
        
        let b = UIView()
        b.backgroundColor = UIColor.white
        b.translatesAutoresizingMaskIntoConstraints = false
        
        
        return b
        
    }()
    
    
    func viewSetter(){
        
        
        
    }
    
}
