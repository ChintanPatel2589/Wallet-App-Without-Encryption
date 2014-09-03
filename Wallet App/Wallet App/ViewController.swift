//
//  ViewController.swift
//  Wallet App
//
//  Created by august on 25/06/14.
//  Copyright (c) 2014 August infotech. All rights reserved.
//
//Wallet App With the New
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var btnTraditional : UIButton?
    @IBOutlet var btnTouchID : UIButton?
    @IBOutlet var btnLogin : UIButton?
    var isTraditional = false
    var isReadyToGo = true
    override func viewDidLoad() {
        super.viewDidLoad()
        NSUserDefaults.standardUserDefaults().setValue("NotRegister", forKey: "Login")
        btnLogin!.layer.borderWidth=1
        btnLogin!.layer.borderColor=UIColor(red: 21/255, green: 125/255, blue: 251/255, alpha: 1).CGColor
        btnLogin!.layer.cornerRadius=10
        //btnLogin!.titleLabel.textColor=UIColor(red: 21/255, green: 125/255, blue: 251/255, alpha: 1)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
     override func viewWillAppear(animated: Bool)
     {
        self.navigationController.navigationBar.hidden=true 
        //self.tabBarController.tabBar.hidden=true
        UIApplication.sharedApplication().statusBarHidden=false
        
        btnTouchID!.setImage(UIImage(named: "RadioUnChecked.png") as UIImage, forState: UIControlState.Normal)
        btnTraditional!.setImage(UIImage(named: "RadioUnChecked.png") as UIImage, forState: UIControlState.Normal)
    }
    @IBAction func checlLoginType(sender:UIButton)
    {
        isReadyToGo=true
        if sender.tag == 1
        {
            //Traditional type
            btnTouchID!.setImage(UIImage(named: "RadioUnChecked.png") as UIImage, forState: UIControlState.Normal)
            btnTraditional!.setImage(UIImage(named: "RadioChecked.png") as UIImage, forState: UIControlState.Normal)
            isTraditional=true
            isReadyToGo=true
        }
        else
        {
            //Touch Id
            btnTraditional!.setImage(UIImage(named: "RadioUnChecked.png") as UIImage, forState: UIControlState.Normal)
            btnTouchID!.setImage(UIImage(named: "RadioChecked.png") as UIImage, forState: UIControlState.Normal)
            isTraditional=false
        }
    }
    @IBAction func checkLoginTypeLabel(sender:UITapGestureRecognizer)
    {
        isReadyToGo=true
        if sender.view.tag == 11
        {
            //Traditional type
            btnTouchID!.setImage(UIImage(named: "RadioUnChecked.png") as UIImage, forState: UIControlState.Normal)
            btnTraditional!.setImage(UIImage(named: "RadioChecked.png") as UIImage, forState: UIControlState.Normal)
            isTraditional=true
        }
        else
        {
            //Touch Id
            btnTraditional!.setImage(UIImage(named: "RadioUnChecked.png") as UIImage, forState: UIControlState.Normal)
            btnTouchID!.setImage(UIImage(named: "RadioChecked.png") as UIImage, forState: UIControlState.Normal)
            isTraditional=false
        }
    }
    @IBAction func gotoRegisterPage()
    {
        if isReadyToGo
        {
            if isTraditional
            {
                var regiOBJ=self.storyboard.instantiateViewControllerWithIdentifier("Register") as RegisterViewController
                isReadyToGo=false
                self.navigationController.pushViewController(regiOBJ, animated: true)
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

