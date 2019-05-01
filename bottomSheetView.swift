//
//  bottomSheetView.swift
//  GondolaShare
//
//  Created by SEIF EL FREJ ISMAIL on 06/04/2019.
//  Copyright © 2019 SEIF EL FREJ ISMAIL. All rights reserved.
//

import UIKit
import FirebaseDatabase

class bottomSheetView: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    let cellID = "cellID"
    
    let IDtv = "ID"
    
    
    
    let blackView = UIView()
    
    
    // Label with name of the station
    let stationNameLabel : UILabel = {
        let l = UILabel()
        l.text = "Accademia station"
        l.textColor = UIColor.black
        l.font = UIFont(name:"HelveticaNeue-Bold", size: l.font.pointSize+3)
        return l
    }()
    
    // Label with name of the station
    let distanceLabel : UILabel = {
        let l = UILabel()
        l.text = "1.5 km"
        l.textColor = UIColor.black
        l.font = UIFont(name:"verdana", size: 12)
        return l
    }()
    
    
    // NavigationBar view
    let barView : UIView = {
        let v = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 60))
        v.isOpaque = true
        v.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 0.9)
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    // Gray bar for sliding
    let slidingBar : UIView = {
        let b = UIView()
        b.backgroundColor = UIColor.gray
        b.layer.cornerRadius = 9
        return b
    }()
    
    // Button to remove bottomshett view
    // REMEMBER TO CHANGE IT TO THE IMAGE FROM IPHONE MAPS
    let xButton : UIButton = {
        let b = UIButton(type: .roundedRect)
        b.frame = CGRect(x: UIScreen.main.bounds.width-30, y: UIScreen.main.bounds.height, width: 82, height: 40)
//        b.layer.cornerRadius = 0.5 * b.bounds.size.width
//        b.clipsToBounds = true
//        b.setTitle("X", for: .normal)
//
//        b.setTitleColor(UIColor.darkGray, for: .normal)
//        b.backgroundColor = UIColor.lightGray
//        b.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        b.backgroundColor = UIColor(red: 61/255, green: 81/255, blue: 181/255, alpha: 1)
        b.layer.cornerRadius = 7
        b.setTitle("Add group", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        
        
        
        return b
        
    }()
    
    // Button that gives directions to the gondola station (not sure whether to implement it in UI)
    // REMEMBER: ADD BUTTON TO UI OR ADD FUNCTION AFTER JOINING GROUP
    let directionButton: UIButton = {
        let b = UIButton()
        return b
    }()
    
    // Collection view that shows waiting lists
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 0.9)
        cv.isScrollEnabled = true
        cv.isSpringLoaded=true
        cv.alwaysBounceVertical=true
        cv.isUserInteractionEnabled=true
        cv.collectionViewLayout.accessibilityScroll(.down)
        cv.translatesAutoresizingMaskIntoConstraints=false
        cv.refreshControl?.isEnabled = true
        return cv
    }()
    
    
    
    let createListButton : UIButton = {
        let but = UIButton(type: .system)
        but.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 1, alpha: 1)
        but.layer.cornerRadius = 7
        but.setTitle("Join", for: .normal)
        but.setTitleColor(UIColor.white, for: .normal)
        but.translatesAutoresizingMaskIntoConstraints=false
        
        return but
    }()
    
    
    var parentViewController:UIViewController!
    
    
    
    @ objc func addWaitingList() {
        
        handleDismiss()
        let addGroup = addGroupViewController()

        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let viewcon = appdelegate.window?.rootViewController
        
        viewcon?.present(addGroup, animated: true, completion: nil)
        
        //viewController.createNewGroup()
        

//        ref.child("Stations/\(nameOfStation)").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//
//            let valueToAdd : [[String:Any]] = [["date":],["name":publicName],["nOfUsers": nOfMyUsers ],["uid": uid]]
//            guard var valueToGet = snapshot.value as? [[String : Any]] else {return}
        
        //})
    }
    
    
    
    @ objc func joinWaitingList() {
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("button at \(indexPath.row)")
    }
    
    
    
    func bottomSheetLauncher(){
        
        if let window = UIApplication.shared.keyWindow{
            
            blackView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            xButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addWaitingList)))
            
            
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            window.addSubview(barView)
            window.addSubview(stationNameLabel)
            window.addSubview(xButton)
            window.addSubview(distanceLabel)
            window.addSubview(slidingBar)
            
            initialSetter()
            
            
            // Adds gesture for bottom sheet vie like slide up
            slidingBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapWasDragged(gestureRecognizer:))))
            slidingBar.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(szWasDragged(gestureRecognizer:))))
            barView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(barViewWasDragged(gestureRecognizer:))))
            
            NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)

            
        }
    }
    
    
    @objc func loadList(notification: NSNotification) {
        self.collectionView.reloadData()
    }
    
    
    // Adds constraints to layout
    func viewSetter(state: Bool){
        
        if let window = UIApplication.shared.keyWindow{
            
            self.barView.centerYAnchor.constraint(equalTo: self.slidingBar.centerYAnchor, constant: 22).isActive=state
            self.barView.centerXAnchor.constraint(equalTo: window.centerXAnchor, constant: 0).isActive=state
            self.barView.widthAnchor.constraint(equalTo: window.widthAnchor, constant: 0).isActive=state
            self.barView.heightAnchor.constraint(equalToConstant: 65).isActive=state
            
            self.collectionView.topAnchor.constraint(equalTo: self.barView.bottomAnchor).isActive=state
            self.collectionView.widthAnchor.constraint(equalTo: window.widthAnchor, constant: 0).isActive=state
            self.collectionView.centerXAnchor.constraint(equalTo: window.centerXAnchor, constant: 0).isActive=state
            self.collectionView.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive=state
            
            self.distanceLabel.translatesAutoresizingMaskIntoConstraints=false
            
            self.distanceLabel.heightAnchor.constraint(equalToConstant: 30).isActive=state
            self.distanceLabel.topAnchor.constraint(equalTo: self.barView.topAnchor, constant: 37).isActive=state
            self.distanceLabel.widthAnchor.constraint(equalToConstant: 300).isActive=state
            self.distanceLabel.leftAnchor.constraint(equalTo: window.leftAnchor, constant: 21).isActive=state
            
            self.slidingBar.centerYAnchor.constraint(equalTo: self.barView.centerYAnchor, constant: -22).isActive=state
            
            
            self.stationNameLabel.translatesAutoresizingMaskIntoConstraints=false
            
            self.stationNameLabel.leftAnchor.constraint(equalTo: window.leftAnchor, constant: 21).isActive=state
            self.stationNameLabel.topAnchor.constraint(equalTo: self.barView.topAnchor, constant: 20).isActive=state
            
            self.xButton.translatesAutoresizingMaskIntoConstraints=false
            
            self.xButton.topAnchor.constraint(equalTo: self.slidingBar.topAnchor, constant: 15).isActive=state
            self.xButton.rightAnchor.constraint(equalTo: window.rightAnchor, constant: -40).isActive=state
            self.xButton.heightAnchor.constraint(equalToConstant: 40).isActive=state
            self.xButton.widthAnchor.constraint(equalToConstant: 82).isActive=state
        }
        
    }
    
    func initialSetter() {
        
        
        if let window = UIApplication.shared.keyWindow{
            counter = 0
            ref.child("Stations/\(nameOfStation)").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                
                guard let valueToGet = snapshot.value as? [[String : Any]] else {
                    
                    counter = 0
                    print(counter)
                    
                    self.slidingBar.frame = CGRect(x: window.frame.width/2 - 50, y: window.frame.height, width: 100, height: 12)
                    self.barView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 65)
                    self.collectionView.frame = CGRect(x: 0, y: window.frame.height + 60, width: window.frame.width, height: window.frame.height)
                    self.blackView.frame = window.frame
                    self.blackView.alpha = 0
                    self.stationNameLabel.frame = CGRect(x: 21, y: window.frame.height, width: 500, height: 30)
                    self.xButton.frame = CGRect(x: window.frame.width-30, y: window.frame.height, width: 20, height: 20)
                    self.distanceLabel.frame = CGRect(x: 21, y: window.frame.height, width: 300, height: 30)
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.slidingBar.frame = CGRect(x: window.frame.width/2 - 50, y: window.frame.height-276, width: 100, height: 12)
                        self.blackView.alpha = 1
                        self.collectionView.frame = CGRect(x: 0, y: window.frame.height-220, width: window.frame.width, height: 220)
                        self.barView.frame = CGRect(x: 0, y: self.slidingBar.frame.minY-4, width: window.frame.width, height: 65)
                        self.stationNameLabel.frame = CGRect(x: 21, y: window.frame.height-267, width: 500, height: 30)
                        self.xButton.frame = CGRect(x: window.frame.width-40, y: window.frame.height-269, width: 82, height: 40)
                        self.distanceLabel.frame = CGRect(x: 27, y: window.frame.height-250, width: 300, height: 30)
                        
                    }, completion: nil)
                    
                    self.viewSetter(state: true)
                    
                    return
                }
                
                
                
                    for i in 0..<valueToGet.count{
                        if valueToGet[i]["nofUsers"] as! Int + nOfMyUsers <= 6, valueToGet[i]["uid"] as! String != uid {
                            counter += 1
                        }
                    }
                     
                    self.collectionView.reloadData()
                    print("counter=\(counter),numberOfItems=\(self.collectionView.numberOfItems(inSection: 0))")
                    
                    //                    if counter != 0, window.subviews.contains(self.createListButton) {
                    //                        self.createListButton.removeFromSuperview()
                    //
                    //                    }
                
            
        
        
        self.slidingBar.frame = CGRect(x: window.frame.width/2 - 50, y: window.frame.height, width: 100, height: 12)
        self.barView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 65)
        self.collectionView.frame = CGRect(x: 0, y: window.frame.height + 60, width: window.frame.width, height: window.frame.height)
        self.blackView.frame = window.frame
        self.blackView.alpha = 0
        self.stationNameLabel.frame = CGRect(x: 21, y: window.frame.height, width: 500, height: 30)
        self.xButton.frame = CGRect(x: window.frame.width-30, y: window.frame.height, width: 20, height: 20)
        self.distanceLabel.frame = CGRect(x: 21, y: window.frame.height, width: 300, height: 30)
     
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.slidingBar.frame = CGRect(x: window.frame.width/2 - 50, y: window.frame.height-276, width: 100, height: 12)
            self.blackView.alpha = 1
            self.collectionView.frame = CGRect(x: 0, y: window.frame.height-220, width: window.frame.width, height: 220)
            self.barView.frame = CGRect(x: 0, y: self.slidingBar.frame.minY-4, width: window.frame.width, height: 65)
            self.stationNameLabel.frame = CGRect(x: 21, y: window.frame.height-267, width: 500, height: 30)
            self.xButton.frame = CGRect(x: window.frame.width-40, y: window.frame.height-269, width: 82, height: 40)
            self.distanceLabel.frame = CGRect(x: 27, y: window.frame.height-250, width: 300, height: 30)
            
        }, completion: nil)
        
        self.viewSetter(state: true)
            })
        }
    }
    
    // Func to remove bottom sheet view
    @objc func handleDismiss(){
        if let window = UIApplication.shared.keyWindow{
        

        
        viewSetter(state: false)
        
        xButton.frame = CGRect(x: window.frame.width-40, y: xButton.frame.minY, width: 82, height: 50)

        UIView.animate(withDuration: 0.25, animations: {
            self.blackView.alpha = 0

            if let window = UIApplication.shared.keyWindow{
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height + 60, width: window.frame.width, height: window.frame.height)
                self.barView.frame = CGRect(x: 0, y: window.frame.height+15, width: window.frame.width, height: 65)
                self.stationNameLabel.frame = CGRect(x: 25, y: window.frame.height, width: 500, height: 30)
                self.xButton.frame = CGRect(x: window.frame.width-40, y: window.frame.height, width: 82, height: 40)
                self.distanceLabel.frame = CGRect(x: 21, y: window.frame.height, width: 300, height: 30)
                self.slidingBar.frame = CGRect(x: window.frame.width/2 - 50, y: window.frame.height+20, width: 100, height: 9)
            }

        })
        
        }
        
        
        
        self.viewSetter(state: true)
        
        //if let window = UIApplication.shared.keyWindow{
        ref.child("Stations/\(nameOfStation)").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            guard let valueToGet = snapshot.value as? [[String : Any]] else { counter = 0;print(counter);self.collectionView.reloadData(); return}
        
        
            self.sthForHandleDismiss(valueToGet: valueToGet)
        
            })
        }
    
    
        
    //}
    
    func sthForHandleDismiss(valueToGet:[[String : Any]]){
        
        
        
            //print(counter)
            counter = 0
            for i in 0..<valueToGet.count{
                if valueToGet[i]["nofUsers"] as! Int + nOfMyUsers <= 6, valueToGet[i]["uid"] as! String != uid {
                    counter += 1
                }
            }
            self.collectionView.reloadData()
            print(counter)
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return counter
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! sharingRideCell
        
        ref.child("Stations/\(nameOfStation)").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            guard var valueToGet = snapshot.value as? [[String : Any]] else {return}
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy HH:mm"
            
            for i in 0 ..< valueToGet.count {
                valueToGet[i]["date"] = dateFormatter.date(from: valueToGet[i]["date"] as! String)!
            }
            
            valueToGet.sort{ ($0["date"] as! Date) < ($1["date"] as! Date) }
            
            
            for i in 0 ..< valueToGet.count {
                valueToGet[i]["date"] = dateFormatter.string(from: valueToGet[i]["date"] as! Date)
            }
            
            ref.child("Stations/\(nameOfStation)").setValue(valueToGet)
            
            cell.personWaitingLabel.numberOfLines = 2
            
            //cell.fullImageView.layer.sublayers?.first
            
            
            cell.personWaitingLabel.text = """
            \(valueToGet[indexPath.row]["date"] as! String)
            \(valueToGet[indexPath.row]["name"] as! String) is with \(String(valueToGet[indexPath.row]["nofUsers"] as! Int)) people
            """
            cell.joinButton.tag = indexPath.row
            
            
            self.setGradientBackground(cell: cell, valueToGet: valueToGet[indexPath.row]["nofUsers"] as! Double, indexPath: indexPath)
            
        })
        
        return cell
    }
    
    func setGradientBackground(cell: sharingRideCell, valueToGet : Double, indexPath: IndexPath) {
        let colorLeft = UIColor(red: 3/255, green: 169/255, blue: 244/255, alpha: 1).cgColor
        let colorRight = UIColor(red: 61/255, green: 81/255, blue: 181/255, alpha: 1).cgColor
        let ratio = valueToGet/6
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = cell.fullImageView.layer.cornerRadius
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 290*ratio, height: 50)
        gradientLayer.colors = [colorLeft, colorRight]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint =  CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint =  CGPoint(x: 1.0/ratio, y: 0.5)
        
        cell.fullImageView.layer.addSublayer(gradientLayer)
        
        cell.fullImageView.layer.sublayers?[0].removeFromSuperlayer()
        cell.fullImageView.layer.insertSublayer(gradientLayer, at: 0)
    
        
    }
        
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width, height: 120)
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    @objc public func tapWasDragged(gestureRecognizer: UITapGestureRecognizer) {
        
        
        
        if let window = UIApplication.shared.keyWindow, Int(gestureRecognizer.view!.frame.minY) != 80{
            
            
            
            viewSetter(state: false)
            
            
            
            collectionView.frame = CGRect(x: 0, y: window.frame.height-220, width: window.frame.width, height: 220)
            barView.frame = CGRect(x: 0, y: self.slidingBar.frame.minY-4, width: window.frame.width, height: 65)
            stationNameLabel.frame = CGRect(x: 21, y: window.frame.height-267, width: 500, height: 30)
            xButton.frame = CGRect(x: window.frame.width-40, y: window.frame.height-269, width: 82, height: 30)
            distanceLabel.frame = CGRect(x: 27, y: window.frame.height-245, width: 300, height: 30)
            
            
            
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                gestureRecognizer.view!.frame = CGRect(x: window.frame.width/2 - 50, y: 80, width: (gestureRecognizer.view?.frame.width)!, height: (gestureRecognizer.view?.frame.height)!)
                
                
                self.barView.frame = CGRect(x: 0, y: 76, width: window.frame.width, height: 65)
                self.collectionView.frame = CGRect(x: 0, y: 141, width: window.frame.width, height: 220)
                self.stationNameLabel.frame = CGRect(x: 21, y: 89, width: 300, height: 30)
                self.xButton.frame = CGRect(x: window.frame.width-40, y: 84, width: 82, height: 40)
                self.distanceLabel.frame = CGRect(x: 27, y: 98, width: 300, height: 30)
                
                
            }, completion: nil)
            
            
            viewSetter(state: true)
            
            
        }
        
        
        
    }
    
    
    var positionArray : [CGFloat] = []
    
    
    @objc public func szWasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let barPosition = slidingBar.frame.maxY
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {
            let translation = gestureRecognizer.translation(in: slidingBar)
            
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x, y: gestureRecognizer.view!.center.y + translation.y)
            
            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: slidingBar)
            
            positionArray.append(barPosition)
            
            
            
        }
        
        if let window = UIApplication.shared.keyWindow{
            
            
            if gestureRecognizer.state == UIGestureRecognizer.State.ended, positionArray[positionArray.count-1] < positionArray[positionArray.count-2]{
                
                viewSetter(state: false)
                
                collectionView.frame = CGRect(x: 0, y: collectionView.frame.minY, width: window.frame.width, height: collectionView.frame.height)
                barView.frame = CGRect(x: 0, y: barView.frame.minY, width: window.frame.width, height: barView.frame.height)
                stationNameLabel.frame = CGRect(x: 21, y: stationNameLabel.frame.minY, width: 500, height: 30)
                xButton.frame = CGRect(x: window.frame.width-40, y: xButton.frame.minY, width: 82, height: 40)
                distanceLabel.frame = CGRect(x: 27, y: distanceLabel.frame.minY, width: 300, height: 30)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    gestureRecognizer.view!.frame = CGRect(x: window.frame.width/2 - 50, y: 80, width: (gestureRecognizer.view?.frame.width)!, height: (gestureRecognizer.view?.frame.height)!)
                    
                    self.barView.frame = CGRect(x: 0, y: 76, width: window.frame.width, height: 65)
                    self.collectionView.frame = CGRect(x: 0, y: 141, width: window.frame.width, height: 220)
                    self.stationNameLabel.frame = CGRect(x: 21, y: 89, width: 300, height: 30)
                    self.xButton.frame = CGRect(x: window.frame.width-40, y: 84, width: 82, height: 40)
                    self.distanceLabel.frame = CGRect(x: 27, y: 98, width: 300, height: 30)
                    
                }, completion: nil)
                
                viewSetter(state: true)
            }
            
            if gestureRecognizer.state == UIGestureRecognizer.State.ended, positionArray[positionArray.count-1] > positionArray[positionArray.count-2]{
                viewSetter(state: false)
                collectionView.frame = CGRect(x: 0, y: collectionView.frame.minY, width: window.frame.width, height: collectionView.frame.height)
                barView.frame = CGRect(x: 0, y: barView.frame.minY, width: window.frame.width, height: barView.frame.height)
                stationNameLabel.frame = CGRect(x: 21, y: stationNameLabel.frame.minY, width: 500, height: 30)
                xButton.frame = CGRect(x: window.frame.width-40, y: xButton.frame.minY, width: 82, height: 30)
                distanceLabel.frame = CGRect(x: 27, y: distanceLabel.frame.minY, width: 300, height: 30)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    gestureRecognizer.view!.frame = CGRect(x: window.frame.width/2 - 50, y: window.frame.height-276, width: (gestureRecognizer.view?.frame.width)!, height: (gestureRecognizer.view?.frame.height)!)
                    
                    self.collectionView.frame = CGRect(x: 0, y: window.frame.height-220, width: window.frame.width, height: 220)
                    self.barView.frame = CGRect(x: 0, y: self.slidingBar.frame.minY-4, width: window.frame.width, height: 65)
                    self.stationNameLabel.frame = CGRect(x: 21, y: window.frame.height-267, width: 500, height: 30)
                    self.xButton.frame = CGRect(x: window.frame.width-40, y: window.frame.height-269, width: 82, height: 50)
                    self.distanceLabel.frame = CGRect(x: 27, y: window.frame.height-245, width: 300, height: 30)
                }, completion: nil)
                viewSetter(state: true)
            }
        }
    }
    
    
    
    @objc public func barViewWasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let barPosition = slidingBar.frame.maxY
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {
            let translation = gestureRecognizer.translation(in: barView)
            
            //gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x, y: gestureRecognizer.view!.center.y + translation.y)
            slidingBar.frame = CGRect(x: slidingBar.frame.minX, y: slidingBar.frame.minY+translation.y, width: slidingBar.frame.width, height: slidingBar.frame.height)
            
            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: barView)
            positionArray.append(barPosition)
        }
        
        if let window = UIApplication.shared.keyWindow{
            
            if gestureRecognizer.state == UIGestureRecognizer.State.ended, positionArray[positionArray.count-1] < positionArray[positionArray.count-2]{
                viewSetter(state: false)
                collectionView.frame = CGRect(x: 0, y: collectionView.frame.minY, width: window.frame.width, height: collectionView.frame.height)
                slidingBar.frame = CGRect(x: self.slidingBar.frame.minX, y: slidingBar.frame.minY, width: slidingBar.frame.width, height: slidingBar.frame.height)
                stationNameLabel.frame = CGRect(x: 21, y: stationNameLabel.frame.minY, width: 500, height: 30)
                xButton.frame = CGRect(x: window.frame.width-40, y: xButton.frame.minY, width: 82, height: 30)
                distanceLabel.frame = CGRect(x: 27, y: distanceLabel.frame.minY, width: 300, height: 30)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    gestureRecognizer.view!.frame = CGRect(x: (gestureRecognizer.view?.frame.minX)!, y: 76, width: (gestureRecognizer.view?.frame.width)!, height: (gestureRecognizer.view?.frame.height)!)
                    
                    self.slidingBar.frame = CGRect(x: self.slidingBar.frame.minX, y: 76, width: self.slidingBar.frame.width, height: 12)
                    self.collectionView.frame = CGRect(x: 0, y: 141, width: window.frame.width, height: 220)
                    self.stationNameLabel.frame = CGRect(x: 21, y: 89, width: 300, height: 30)
                    self.xButton.frame = CGRect(x: window.frame.width-40, y: 84, width: 82, height: 40)
                    self.distanceLabel.frame = CGRect(x: 27, y: 98, width: 300, height: 30)
                }, completion: nil)
                viewSetter(state: true)
                
            }
            
            if gestureRecognizer.state == UIGestureRecognizer.State.ended, positionArray[positionArray.count-1] > positionArray[positionArray.count-2]{
                viewSetter(state: false)
                collectionView.frame = CGRect(x: 0, y: collectionView.frame.minY, width: window.frame.width, height: collectionView.frame.height)
                slidingBar.frame = CGRect(x: self.slidingBar.frame.minX, y: slidingBar.frame.minY, width: slidingBar.frame.width, height: 12)
                stationNameLabel.frame = CGRect(x: 21, y: stationNameLabel.frame.minY, width: 500, height: 30)
                xButton.frame = CGRect(x: window.frame.width-40, y: xButton.frame.minY, width: 82, height: 30)
                distanceLabel.frame = CGRect(x: 27, y: distanceLabel.frame.minY, width: 300, height: 30)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    gestureRecognizer.view!.frame = CGRect(x: (gestureRecognizer.view?.frame.minX)!, y: window.frame.height-280, width: (gestureRecognizer.view?.frame.width)!, height: (gestureRecognizer.view?.frame.height)!)
                    
                    self.collectionView.frame = CGRect(x: 0, y: window.frame.height-220, width: window.frame.width, height: 220)
                    self.slidingBar.frame = CGRect(x: self.slidingBar.frame.minX, y: window.frame.height-276, width: self.slidingBar.frame.width, height: 12)
                    self.stationNameLabel.frame = CGRect(x: 21, y: window.frame.height-267, width: 500, height: 30)
                    self.xButton.frame = CGRect(x: window.frame.width-40, y: window.frame.height-269, width: 82, height: 40)
                    self.distanceLabel.frame = CGRect(x: 27, y: window.frame.height-245, width: 300, height: 30)
                }, completion: nil)
                
                viewSetter(state: true)
                
            }
        }
    }
    
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        collectionView.register(sharingRideCell.self, forCellWithReuseIdentifier: cellID)
        
    }
}

