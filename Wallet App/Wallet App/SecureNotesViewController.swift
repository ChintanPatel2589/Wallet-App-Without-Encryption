//
//  SecureNotesViewController.swift
//  Wallet App
//
//  Created by August Infotech on 7/15/14.
//  Copyright (c) 2014 August infotech. All rights reserved.
//

import UIKit

class SecureNotesViewController: UIViewController ,UITabBarDelegate,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate {
    var isDatePickerUp = false
    var dataDic = NSMutableDictionary()
    var isEdit = false
    var lastTextField = UITextField()
    
    
    @IBOutlet var scrollView : UIScrollView?
    
    @IBOutlet var txtName : UITextField?
    @IBOutlet var txtViewNote : UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Secure Notes"
        self.navigationController.navigationBar.translucent=false
        self.navigationController.navigationBar.barTintColor=UIColor(red: 252.0/255, green: 173.0/255, blue: 83.0/255, alpha: 1)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController.navigationBar.titleTextAttributes = titleDict
        self.scrollView!.contentSize=CGSizeMake(320, self.view.frame.height)
        if isEdit
        {
            var rightDoneBtn = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Bordered, target: self, action: "Edit")
            self.navigationItem.rightBarButtonItem=rightDoneBtn
            
            txtName!.text=self.dataDic.valueForKey("Name") as String
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
        var editResult = api_Database.genericQueryforDatabase(DATABASENAME, query: NSString(format:"update SecureNotes set Name=%@,Notes=%@ where UID='%@'",api_Database.escape(txtName!.text),api_Database.escape(txtViewNote!.text),self.dataDic.valueForKey("UID") as String))
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
            alert("Error", text: "Ooppsss..Something Getting Wrong. Please Try Again With Valid Data.")
        }
    }
    
    func done() //Save Data Insert New Data
    {
        println("done")
        
        var SpaceCharSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        
        if txtName!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 || txtName!.text.stringByTrimmingCharactersInSet(SpaceCharSet).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
        {
            self.alert("Error", text: "Please Enter Subject")
            self.txtName!.becomeFirstResponder()
            return
        }
        
        api_Database.createTable("CREATE TABLE IF NOT EXISTS SecureNotes (UID TEXT,Name TEXT, Notes TEXT)", dbName: DATABASENAME)
        //api_Database.createTable("CREATE TABLE IF NOT EXISTS test (Name TEXT, City TEXT)", dbName: DATABASENAME)
        
        var result=api_Database.genericQueryforDatabase(DATABASENAME, query:NSString(format:"insert into SecureNotes(UID,Name,Notes) values('%@',%@,%@)",NSUUID.UUID().UUIDString,api_Database.escape(txtName!.text),api_Database.escape(txtViewNote!.text)) as String)
        
        if result
        {
            self.dismissViewControllerAnimated(true, completion: {
                NSNotificationCenter.defaultCenter().postNotificationName("viewDismiss", object: nil)
                })
        }
        else
        {
            alert("Error", text: "Ooppssss..Something Getting Wrong. Plase Try Again.")
        }
    }
    func cancel()
    {
        println("cancel")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func setTextFieldGrayColor()
    {
        txtName!.textColor=UIColor.grayColor()
        txtViewNote!.textColor=UIColor.grayColor()

        txtName!.enabled=false
        
     
        
        txtViewNote!.editable=false
        txtViewNote!.selectable=false
    }
    func setTextfieldBlackColor()
    {
        txtName!.textColor=UIColor.blackColor()
        
        txtViewNote!.textColor=UIColor.blackColor()
        
        
        txtName!.enabled=true
        
        
        
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
        scrollView!.setContentOffset(CGPointMake(0, textView.center.y-90), animated: true)
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
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
