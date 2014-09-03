//
//  WebLoginViewController.swift
//  Wallet App
//
//  Created by august on 30/06/14.
//  Copyright (c) 2014 August infotech. All rights reserved.
//

import UIKit

class WebLoginViewController: UIViewController ,UITabBarDelegate,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate {

    var dataDic = NSMutableDictionary()
    var isEdit = false
    var lastTextField = UITextField()
    
    @IBOutlet var scrollView : UIScrollView?
    
    @IBOutlet var txtAccountName : UITextField?
    @IBOutlet var txtOwnerName : UITextField?
   // @IBOutlet var txtCategory : UITextField
   // @IBOutlet var txtCurrency : UITextField
    @IBOutlet var txtLogin : UITextField?
    @IBOutlet var txtPassword :UITextField?
    @IBOutlet var txtWebsite :UITextField?
    @IBOutlet var txtViewNote : UITextView?
    
    override func viewDidLoad() {
            super.viewDidLoad()
            self.title="Web Login"
        self.navigationController.navigationBar.translucent=false
            self.scrollView!.contentSize=CGSizeMake(320, 420)
        self.navigationController.navigationBar.barTintColor=UIColor(red: 252.0/255, green: 173.0/255, blue: 83.0/255, alpha: 1)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController.navigationBar.titleTextAttributes = titleDict
            // Do any additional setup after loading the view.
            if isEdit
            {
                var rightDoneBtn = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Bordered, target: self, action: "Edit")
                self.navigationItem.rightBarButtonItem=rightDoneBtn

                txtAccountName!.text=self.dataDic.valueForKey("AccountName") as String
                txtOwnerName!.text=self.dataDic.valueForKey("Name") as String
               // txtCategory.text=self.dataDic.valueForKey("Category") as String
                //txtCurrency.text=self.dataDic.valueForKey("Currency") as String
                txtLogin!.text=self.dataDic.valueForKey("Login") as String
                txtPassword!.text=self.dataDic.valueForKey("Password") as String
                txtWebsite!.text=self.dataDic.valueForKey("Website") as String
                txtViewNote!.text=self.dataDic.valueForKey("Notes") as String

                setTextFieldGrayColor() //Function call for set textfield editabel false and color

            }
            else
            {
                // Add new data
                var rightDoneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "done")
                self.navigationItem.rightBarButtonItem=rightDoneBtn
                var leftDoneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel")
                self.navigationItem.leftBarButtonItem=leftDoneBtn
            }
        self.txtViewNote!.layer.cornerRadius = 5
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
    func Edit() //Start Editing and set alll text field editabel true
    {
        var rightDoneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "Editdone")
        self.navigationItem.rightBarButtonItem=rightDoneBtn
        setTextfieldBlackColor() //Function for setting editable true and text color to black
    }
    func Editdone() //Editing Done Update Data
    {
        var editResult = api_Database.genericQueryforDatabase(DATABASENAME, query: NSString(format:"update webLogin set AccountName=%@,Name=%@,Login=%@,Password='%@',Website='%@',Notes=%@ where UID='%@'",api_Database.escape( txtAccountName!.text),api_Database.escape(txtOwnerName!.text),api_Database.escape(txtLogin!.text),txtPassword!.text,txtWebsite!.text,api_Database.escape(txtViewNote!.text),self.dataDic.valueForKey("UID") as String))
        if editResult
        {
            self.lastTextField.resignFirstResponder()
            scrollView!.setContentOffset(CGPointMake(0, -5), animated: true)
            setTextFieldGrayColor() //Function for set editable false and text color gray
            var rightDoneBtn = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Bordered, target: self, action: "Edit")
            self.navigationItem.rightBarButtonItem=rightDoneBtn
        }
        else
        {
            alert("Error", text: "ooppsss..Something getting Wrong. Please try Again with valid Data.")
        }
    }
    
    func done() //Save Data Insert New Data
    {
        println("done")
    
        var SpaceCharSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        
        if txtAccountName!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 || txtAccountName!.text.stringByTrimmingCharactersInSet(SpaceCharSet).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
        {
            self.alert("Error", text: "Please Enter Name")
            self.txtAccountName!.becomeFirstResponder()
            return
        }
        if txtLogin!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 || txtLogin!.text.stringByTrimmingCharactersInSet(SpaceCharSet).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
        {
            self.alert("Error", text: "Please Enter Login ID")
            self.txtLogin!.becomeFirstResponder()
            return
        }
        
        if txtPassword!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 || txtPassword!.text.stringByTrimmingCharactersInSet(SpaceCharSet).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
        {
            self.alert("Error", text: "Please Enter Password")
            self.txtPassword!.becomeFirstResponder()
            return
        }
        
        api_Database.createTable("CREATE TABLE IF NOT EXISTS webLogin (UID TEXT,AccountName TEXT, Name TEXT, Login TEXT, Password TEXT, Website TEXT, Notes TEXT)", dbName: DATABASENAME)
        //api_Database.createTable("CREATE TABLE IF NOT EXISTS test (Name TEXT, City TEXT)", dbName: DATABASENAME)
        
        var result=api_Database.genericQueryforDatabase(DATABASENAME, query:NSString(format:"insert into webLogin(UID,AccountName,Name,Login,Password,Website,Notes) values('%@',%@,%@,%@,'%@','%@',%@)",NSUUID.UUID().UUIDString,api_Database.escape( txtAccountName!.text),api_Database.escape(txtOwnerName!.text),api_Database.escape(txtLogin!.text),txtPassword!.text,txtWebsite!.text,api_Database.escape(txtViewNote!.text)) as String)
    
            if result
            {
                self.dismissViewControllerAnimated(true, completion: {
                    NSNotificationCenter.defaultCenter().postNotificationName("viewDismiss", object: nil)
                    })
            }
            else
            {
                alert("Error", text: "ooppssss..Something getting wrong. Plase try again.")
            }
        }
        func cancel()
        {
            println("cancel")
           self.dismissViewControllerAnimated(true, completion: nil)
        }
    func setTextFieldGrayColor()
    {
            txtAccountName!.textColor=UIColor.grayColor()
            txtOwnerName!.textColor=UIColor.grayColor()
            txtLogin!.textColor=UIColor.grayColor()
            txtPassword!.textColor=UIColor.grayColor()
            txtWebsite!.textColor=UIColor.grayColor()
        
            txtViewNote!.textColor=UIColor.grayColor()
            txtViewNote!.textColor=UIColor.grayColor()

            txtAccountName!.enabled=false
            txtOwnerName!.enabled=false
            txtLogin!.enabled=false
            txtPassword!.enabled=false
            txtWebsite!.enabled=false
        
            txtViewNote!.editable=false
            txtViewNote!.selectable=false
    }
    func setTextfieldBlackColor()
    {
            txtAccountName!.textColor=UIColor.blackColor()
            txtOwnerName!.textColor=UIColor.blackColor()
            txtLogin!.textColor=UIColor.blackColor()
            txtPassword!.textColor=UIColor.blackColor()
            txtWebsite!.textColor=UIColor.blackColor()
        
            
            txtViewNote!.textColor=UIColor.blackColor()
            txtViewNote!.textColor=UIColor.blackColor()
            
            txtAccountName!.enabled=true
            txtOwnerName!.enabled=true
            txtLogin!.enabled=true
            txtPassword!.enabled=true
            txtWebsite!.enabled=true
        
            txtViewNote!.editable=true
            txtViewNote!.selectable=true
            txtViewNote!.editable=true
            txtViewNote!.selectable=true
    }
    
    func textFieldDidBeginEditing(textField: UITextField!)
    {
        self.lastTextField = textField
        scrollView!.setContentOffset(CGPointMake(0, textField.center.y-20), animated: true)

    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        textField.resignFirstResponder()
        scrollView!.setContentOffset(CGPointMake(0, 0), animated: true)
        return true
    }
    
    func  textViewDidBeginEditing(textView: UITextView!)
    {
        scrollView!.setContentOffset(CGPointMake(0, textView.center.y-55), animated: true)
    }
    
    func textView(textView: UITextView!, shouldChangeTextInRange range: NSRange, replacementText text: String!) -> Bool
    {
        if text == "\n"
        {
            textView.resignFirstResponder()
            scrollView!.setContentOffset(CGPointMake(0, 0), animated: true)
            return  true
        }
        else
        {
            return true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
