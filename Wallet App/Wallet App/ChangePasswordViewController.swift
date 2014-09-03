//
//  ChangePasswordViewController.swift
//  Wallet App
//
//  Created by August Infotech on 7/17/14.
//  Copyright (c) 2014 August infotech. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var btnCancel : UIButton?
    @IBOutlet var btnDone : UIButton?
    
    @IBOutlet var txtCurrentPass : UITextField?
    @IBOutlet var txtNewPass : UITextField?
    @IBOutlet var txtConfirmPass : UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController.navigationBar.translucent=false
        self.title = "Change Password"
        self.navigationController.navigationBar.barTintColor=UIColor(red: 252.0/255, green: 173.0/255, blue: 83.0/255, alpha: 1)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController.navigationBar.titleTextAttributes = titleDict
        
        
//        btnCancel!.layer.borderWidth=10
//        btnCancel!.layer.borderColor=UIColor.whiteColor().CGColor
//        btnCancel!.layer.cornerRadius=btnCancel!.frame.size.width/2
//        
//        btnDone!.layer.borderWidth=10
//        btnDone!.layer.borderColor=UIColor.whiteColor().CGColor
//        btnDone!.layer.cornerRadius=btnDone!.frame.size.width/2
        
        btnCancel!.layer.borderWidth=1
        btnCancel!.layer.borderColor=UIColor(red: 21/255, green: 125/255, blue: 251/255, alpha: 1).CGColor
        btnCancel!.layer.cornerRadius=10
        
        btnDone!.layer.borderWidth=1
        btnDone!.layer.borderColor=UIColor(red: 21/255, green: 125/255, blue: 251/255, alpha: 1).CGColor
        btnDone!.layer.cornerRadius=10
        
        txtCurrentPass!.becomeFirstResponder()
        
//        var leftDoneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel")
//        self.navigationItem.leftBarButtonItem=leftDoneBtn
        
//        var backBtn = UIBarButtonItem(title: "Setting", style: UIBarButtonItemStyle.Bordered, target: nil, action: "cancel")
//        self.navigationItem.leftBarButtonItem=backBtn
        
//
//        var rightDoneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "done")
//        self.navigationItem.rightBarButtonItem=rightDoneBtn
        // Do any additional setup after loading the view.
    }
   @IBAction func cancel()
    {
        //self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController.popViewControllerAnimated(true)
    }
     func done()
    {
        var SpaceCharSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        
        if txtCurrentPass!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 || txtCurrentPass!.text.stringByTrimmingCharactersInSet(SpaceCharSet).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
        {
            self.alert("Error", text: "Please Enter Current Password")
            self.txtCurrentPass!.becomeFirstResponder()
            return
        }
        if txtCurrentPass!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) < 6
        {
            self.alert("Error", text: "The Current Password Is Too Short: It Must Be At Least 6 Characters Long.")
            self.txtCurrentPass!.becomeFirstResponder()
            return
        }
        if txtNewPass!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 || txtNewPass!.text.stringByTrimmingCharactersInSet(SpaceCharSet).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
        {
            self.alert("Error", text: "Please Enter New Password")
            self.txtNewPass!.becomeFirstResponder()
            return
        }
        if txtNewPass!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) < 6
        {
            self.alert("Error", text: "The New Password Is Too Short: It Must Be At Least 6 Characters Long.")
            self.txtNewPass!.becomeFirstResponder()
            return
        }
        if txtConfirmPass!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 || txtConfirmPass!.text.stringByTrimmingCharactersInSet(SpaceCharSet).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
        {
            self.alert("Error", text: "Please Enter Confirm Password")
            self.txtConfirmPass!.becomeFirstResponder()
            return
        }
        if txtConfirmPass!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) < 6
        {
            self.alert("Error", text: "The Confirm Password Is Too Short: It Must Be At Least 6 Characters Long.")
            self.txtConfirmPass!.becomeFirstResponder()
            return
        }
        if (NSUserDefaults.standardUserDefaults().valueForKey("Password") as String) != txtCurrentPass!.text
        {
            alert("Error", text: "Current Password Does Not Match")
            return
        }
        if txtNewPass!.text != txtConfirmPass!.text
        {
            self.alert("Error", text: "Both Password Does Not Match. Please Enter Correct Password.")
            self.txtNewPass!.becomeFirstResponder()
            return
        }
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "Password")
        NSUserDefaults.standardUserDefaults().setObject(self.txtNewPass!.text as String, forKey: "Password")
       // println(NSUserDefaults.standardUserDefaults().objectForKey("Password"))
        self.navigationController.popViewControllerAnimated(true)
    }
    func alert(title:NSString, text:NSString)
    {
        
        let alert = UIAlertView()
        alert.title = title
        alert.message = text
        alert.addButtonWithTitle("Ok")
        alert.tag=101
        alert.delegate=self
        alert.show()
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        textField.resignFirstResponder()
       // scrollView!.setContentOffset(CGPointMake(0, 0), animated: true)
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
