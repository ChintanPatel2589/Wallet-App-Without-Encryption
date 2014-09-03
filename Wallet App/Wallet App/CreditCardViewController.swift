//
//  CreditCardViewController.swift
//  Wallet App
//
//  Created by august on 27/06/14.
//  Copyright (c) 2014 August infotech. All rights reserved.
//

import UIKit

class CreditCardViewController: UIViewController ,UITabBarDelegate,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    
    //@IBOutlet var tabBar : UITabBar
    var dataDic = NSMutableDictionary()
    var isEdit = false
    var isCreditCard = false
    var lastTextField = UITextField()
    
    var tmpTypeText : NSString?

    // Picker Card Type
    var pickerOfType = ""
    var isPickerViewUp = false
    @IBOutlet var pickerView : UIPickerView?
    @IBOutlet var viewPicker : UIView?
    var selectedPickerItem = ""
    @IBOutlet var toolBarTitle : UIBarButtonItem?
    var ArrayPickerItem : NSMutableArray = []
    
    
    @IBOutlet var scrollView : UIScrollView?
    @IBOutlet var txtBankName : UITextField?
    @IBOutlet var txtOwnerName : UITextField?
    //@IBOutlet var txtCategory : UITextField
    @IBOutlet var txtType : UITextField?
    @IBOutlet var txtNumber : UITextField?
    @IBOutlet var txtExpirationMonth :UITextField?
    @IBOutlet var txtExpirationYear :UITextField?
    @IBOutlet var txtCCV : UITextField?
    @IBOutlet var txtPin : UITextField?
    @IBOutlet var txtiBanking : UITextField?
    @IBOutlet var txtLoginInternetBanking : UITextField?
    @IBOutlet var txtPass : UITextField?
    @IBOutlet var txtSupportPhone : UITextField?
    @IBOutlet var txtContactEmail : UITextField?
    @IBOutlet var txtViewNote : UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController.navigationBar.translucent=false
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController.navigationBar.titleTextAttributes = titleDict

        if isCreditCard
        {
            self.title="Credit Card"
           // txtType.text="Credit Card"
        }
        else
        {
            self.title="Debit Card"
           // txtType.text="Debit Card"
        }
       
        //println("\(tmpo)")
        self.navigationController.navigationBar.barTintColor=UIColor(red: 252.0/255, green: 173.0/255, blue: 83.0/255, alpha: 1)
        self.scrollView!.contentSize=CGSizeMake(320, 600)

        if isEdit
        {
            var rightDoneBtn = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Bordered, target: self, action: "Edit")
            self.navigationItem.rightBarButtonItem=rightDoneBtn
            
            txtBankName!.text=self.dataDic.valueForKey("BankName") as String
            txtOwnerName!.text=self.dataDic.valueForKey("Name") as String
           // txtCategory.text=self.dataDic.valueForKey("Category") as String
            txtType!.text=self.dataDic.valueForKey("Type") as String
           
            txtNumber!.text=self.dataDic.valueForKey("CardNumber") as String
            txtExpirationMonth!.text=self.dataDic.valueForKey("ExpMonth") as String
            txtExpirationYear!.text=self.dataDic.valueForKey("ExpYear") as String
            txtCCV!.text=self.dataDic.valueForKey("CCVCode") as String
            txtPin!.text=self.dataDic.valueForKey("Pin") as String
            txtiBanking!.text=self.dataDic.valueForKey("iBankingLogin") as String
            txtLoginInternetBanking!.text=self.dataDic.valueForKey("iBankingLoginID") as String
            txtPass!.text=self.dataDic.valueForKey("loginPassword") as String
            txtSupportPhone!.text=self.dataDic.valueForKey("Phone") as String
            txtContactEmail!.text=self.dataDic.valueForKey("Email") as String
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
    override func viewWillAppear(animated: Bool)
    {
        //Type PickerView Frame Setting
        var rViewDatepicker = self.viewPicker!.frame as CGRect
        rViewDatepicker.origin.y = self.view.frame.size.height + 1
        self.viewPicker!.frame=rViewDatepicker
        
       
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
        if isCreditCard{
            var editResult = api_Database.genericQueryforDatabase(DATABASENAME, query: NSString(format:"update creditCard set BankName=%@,Name=%@,Category='%@',Type='%@',CardNumber='%@',ExpMonth='%@',ExpYear='%@',CCVCode='%@',Pin='%@',iBankingLogin='%@',iBankingLoginID='%@',loginPassword='%@',Phone='%@',Email='%@',Notes=%@ where UID='%@'",api_Database.escape(txtBankName!.text),api_Database.escape(txtOwnerName!.text),"Credit Card",txtType!.text,txtNumber!.text,txtExpirationMonth!.text,txtExpirationYear!.text,txtCCV!.text,txtPin!.text,txtiBanking!.text,txtLoginInternetBanking!.text, txtPass!.text,txtSupportPhone!.text,txtContactEmail!.text,api_Database.escape(txtViewNote!.text),self.dataDic.valueForKey("UID") as String))
            
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
        else
        {
            var editResult = api_Database.genericQueryforDatabase(DATABASENAME, query: NSString(format:"update DebitCard set BankName=%@,Name=%@,Category='%@',Type='%@',CardNumber='%@',ExpMonth='%@',ExpYear='%@',CCVCode='%@',Pin='%@',iBankingLogin='%@',iBankingLoginID='%@',loginPassword='%@',Phone='%@',Email='%@',Notes=%@ where UID='%@'",api_Database.escape(txtBankName!.text),api_Database.escape(txtOwnerName!.text),"Credit Card",txtType!.text,txtNumber!.text,txtExpirationMonth!.text,txtExpirationYear!.text,txtCCV!.text,txtPin!.text,txtiBanking!.text,txtLoginInternetBanking!.text,txtPass!.text,txtSupportPhone!.text,txtContactEmail!.text,api_Database.escape(txtViewNote!.text),self.dataDic.valueForKey("UID") as String))
            
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
    }
    
    func done() //Save Data Insert New Data
    {
        println("done")
        var SpaceCharSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        if txtBankName!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 || txtBankName!.text.stringByTrimmingCharactersInSet(SpaceCharSet).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
        {
            self.alert("Error", text: "Please Enter Bank Name")
            self.txtBankName!.text = ""
            self.txtBankName!.becomeFirstResponder()
            return
        }
        if txtType!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 || txtType!.text.stringByTrimmingCharactersInSet(SpaceCharSet).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
        {
            self.alert("Error", text: "Please Select Type")
            self.txtType!.becomeFirstResponder()
            return
        }
        else if txtType!.text == "--" || txtType!.text.stringByTrimmingCharactersInSet(SpaceCharSet).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
        {
            self.alert("Error", text: "Please Select Type")
            self.txtType!.becomeFirstResponder()
            return
        }
        if txtNumber!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 || txtNumber!.text.stringByTrimmingCharactersInSet(SpaceCharSet).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
        {
            self.alert("Error", text: "Please Enter Card Number")
            self.txtNumber!.becomeFirstResponder()
            return
        }
        if txtExpirationMonth!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding).toIntMax() > 0
        {
            if txtExpirationMonth!.text.toInt()  > 12 || txtExpirationMonth!.text.toInt() <= 0
            {
                alert("Error", text: "Please Select Month Between 1 to 12.")
                return
            }
        }
        else
        {
            self.alert("Error", text: "Please Select Expiration Month")
            self.txtExpirationMonth!.becomeFirstResponder()
            return
        }
        
        if txtExpirationYear!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
        {
            self.alert("Error", text: "Please Select Expiration Year")
            self.txtExpirationYear!.becomeFirstResponder()
            return
        }
        if txtCCV!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 || txtCCV!.text.stringByTrimmingCharactersInSet(SpaceCharSet).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
        {
            self.alert("Error", text: "Please Enter CCV/CVC Code.")
            self.txtCCV!.becomeFirstResponder()
            return
        }
        if txtPin!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 || txtPin!.text.stringByTrimmingCharactersInSet(SpaceCharSet).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
        {
            self.alert("Error", text: "Please Enter PIN")
            self.txtPin!.becomeFirstResponder()
            return
        }
        if txtContactEmail!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding).toIntMax() > 0
        {
            if !api_Database.validEmail(txtContactEmail!.text)
            {
                alert("Error", text: "Enter Valid E-Mail")
                return
            }
        }
        if isCreditCard
        {
            api_Database.createTable("CREATE TABLE IF NOT EXISTS creditCard (UID TEXT,BankName TEXT, Name TEXT, Category TEXT, Type TEXT, CardNumber TEXT, ExpMonth TEXT, ExpYear TEXT, CCVCode TEXT, Pin TEXT, iBankingLogin TEXT,iBankingLoginID TEXT, loginPassword TEXT, Phone TEXT, Email TEXT, Notes TEXT)", dbName: DATABASENAME)
            //api_Database.createTable("CREATE TABLE IF NOT EXISTS test (Name TEXT, City TEXT)", dbName: DATABASENAME)
            
            var result=api_Database.genericQueryforDatabase(DATABASENAME, query:NSString(format:"insert into creditCard(UID,BankName,Name,Category,Type,CardNumber,ExpMonth,ExpYear,CCVCode,Pin,iBankingLogin,iBankingLoginID,loginPassword,Phone,Email,Notes) values('%@',%@,%@,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%@)",NSUUID.UUID().UUIDString,api_Database.escape(txtBankName!.text),api_Database.escape(txtOwnerName!.text),"Credit Card",txtType!.text,txtNumber!.text,txtExpirationMonth!.text,txtExpirationYear!.text,txtCCV!.text,txtPin!.text,txtiBanking!.text,txtLoginInternetBanking!.text, txtPass!.text,txtSupportPhone!.text,txtContactEmail!.text,api_Database.escape(txtViewNote!.text)) as String)
            
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
        else
        {
            api_Database.createTable("CREATE TABLE IF NOT EXISTS DebitCard (UID TEXT,BankName TEXT, Name TEXT, Category TEXT, Type TEXT, CardNumber TEXT, ExpMonth TEXT, ExpYear TEXT, CCVCode TEXT, Pin TEXT, iBankingLogin TEXT,iBankingLoginID TEXT, loginPassword TEXT, Phone TEXT, Email TEXT, Notes TEXT)", dbName: DATABASENAME)
            //api_Database.createTable("CREATE TABLE IF NOT EXISTS test (Name TEXT, City TEXT)", dbName: DATABASENAME)
            
            var result=api_Database.genericQueryforDatabase(DATABASENAME, query:NSString(format:"insert into DebitCard(UID,BankName,Name,Category,Type,CardNumber,ExpMonth,ExpYear,CCVCode,Pin,iBankingLogin,iBankingLoginID,loginPassword,Phone,Email,Notes) values('%@',%@,%@,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%@)",NSUUID.UUID().UUIDString,api_Database.escape(txtBankName!.text),api_Database.escape(txtOwnerName!.text),"Credit Card",txtType!.text,txtNumber!.text,txtExpirationMonth!.text,txtExpirationYear!.text,txtCCV!.text,txtPin!.text,txtiBanking!.text,txtLoginInternetBanking!.text,txtPass!.text,txtSupportPhone!.text,txtContactEmail!.text,api_Database.escape(txtViewNote!.text)) as String)
            
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
       
    }
    func cancel()
    {
        println("cancel")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func setTextFieldGrayColor()
    {
        txtBankName!.textColor=UIColor.grayColor()
        txtOwnerName!.textColor=UIColor.grayColor()
       // txtCategory.textColor=UIColor.grayColor()
        txtType!.textColor=UIColor.grayColor()
        txtNumber!.textColor=UIColor.grayColor()
        txtExpirationMonth!.textColor=UIColor.grayColor()
        txtExpirationYear!.textColor=UIColor.grayColor()
        txtCCV!.textColor=UIColor.grayColor()
        txtPin!.textColor=UIColor.grayColor()
        txtiBanking!.textColor=UIColor.grayColor()
        txtLoginInternetBanking!.textColor=UIColor.grayColor()
        txtPass!.textColor=UIColor.grayColor()
        txtSupportPhone!.textColor=UIColor.grayColor()
        txtContactEmail!.textColor=UIColor.grayColor()
        txtViewNote!.textColor=UIColor.grayColor()
        txtViewNote!.textColor=UIColor.grayColor()
        
        txtBankName!.enabled=false
        txtOwnerName!.enabled=false
       // txtCategory.enabled=false
        txtType!.enabled=false
        txtNumber!.enabled=false
        txtExpirationMonth!.enabled=false
        txtExpirationYear!.enabled=false
        txtCCV!.enabled=false
        txtPin!.enabled=false
        txtiBanking!.enabled=false
        txtLoginInternetBanking!.enabled=false
        txtPass!.enabled=false
        txtSupportPhone!.enabled=false
        txtContactEmail!.enabled=false
        txtViewNote!.editable=false
        txtViewNote!.selectable=false
    }
    func setTextfieldBlackColor()
    {
        txtBankName!.textColor=UIColor.blackColor()
        txtOwnerName!.textColor=UIColor.blackColor()
        //txtCategory.textColor=UIColor.blackColor()
        txtType!.textColor=UIColor.blackColor()
        txtNumber!.textColor=UIColor.blackColor()
        txtExpirationMonth!.textColor=UIColor.blackColor()
        txtExpirationYear!.textColor=UIColor.blackColor()
        txtCCV!.textColor=UIColor.blackColor()
        txtPin!.textColor=UIColor.blackColor()
        txtiBanking!.textColor=UIColor.blackColor()
        txtLoginInternetBanking!.textColor=UIColor.blackColor()
        txtPass!.textColor=UIColor.blackColor()
        txtSupportPhone!.textColor=UIColor.blackColor()
        txtContactEmail!.textColor=UIColor.blackColor()
        txtViewNote!.textColor=UIColor.blackColor()
        txtViewNote!.textColor=UIColor.blackColor()
        
        txtBankName!.enabled=true
        txtOwnerName!.enabled=true
        //txtCategory.enabled=true
        txtType!.enabled=true
        txtNumber!.enabled=true
        txtExpirationMonth!.enabled=true
        txtExpirationYear!.enabled=true
        txtCCV!.enabled=true
        txtPin!.enabled=true
        txtiBanking!.enabled=true
        txtLoginInternetBanking!.enabled=true
        txtPass!.enabled=true
        txtSupportPhone!.enabled=true
        txtContactEmail!.enabled=true
        txtViewNote!.editable=true
        txtViewNote!.selectable=true
    }

    func textFieldDidBeginEditing(textField: UITextField!)
    {
        self.lastTextField.resignFirstResponder()
        self.lastTextField = textField
        self.tmpTypeText = self.txtType!.text
        //println("\(self.tmpTypeText)")
        scrollView!.setContentOffset(CGPointMake(0, textField.center.y-20), animated: true)
        if textField.tag == 3
        {
            self.pickerOfType = "CardType"
            self.isPickerViewUp = true
            self.ArrayPickerItem = ["--","VISA","Master Card","Maestro","American Express"]
            self.toolBarTitle!.title = "- Select Card Type -"
            self.view.bringSubviewToFront(self.viewPicker)
            
            getUpPickerView()
            
            self.tmpTypeText = self.txtType!.text
//            if self.txtType!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
//            {
//                self.txtType!.text=self.ArrayPickerItem.objectAtIndex(0) as String
//            }
        }
       else if textField.tag == 1008 //Month Picker
        {
            self.toolBarTitle!.title = "- Select Month -"
            self.pickerOfType = "MonthPicker"
            self.ArrayPickerItem = ["--","01","02","03","04","05","06","07","08","09","10","11","12"]
            
            self.view.bringSubviewToFront(self.viewPicker)
            getUpPickerView()
            self.tmpTypeText = self.txtExpirationMonth!.text
        }
        else if textField.tag == 1009 //Year Picker
        {
            self.toolBarTitle!.title = "- Select Year -"
            self.pickerOfType = "YearPicker"
            self.ArrayPickerItem = api_Database.getYears() as NSMutableArray
            
            self.view.bringSubviewToFront(self.viewPicker)
            getUpPickerView()
            self.tmpTypeText = self.txtExpirationMonth!.text
        }
        else
        {
            if self.isPickerViewUp
            {
                hidePickerView()
                self.isPickerViewUp = false
            }
        }
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
                scrollView!.setContentOffset(CGPointMake(0, textView.frame.origin.y-330), animated: true)
                return  true
            }
        else
            {
                return true
            }
    }
    //Picker View Method
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int
    {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int
    {
            return self.ArrayPickerItem.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String!
    {
            return self.ArrayPickerItem.objectAtIndex(row) as String
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        self.selectedPickerItem = self.ArrayPickerItem.objectAtIndex(row) as String
    }
    @IBAction func tooBarCancel()
    {
        hidePickerView()
        if self.pickerOfType == "CardType"
        {
            if self.txtType!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
            {
                self.txtType!.text = ""
            }
            else
            {
                self.txtType!.text = self.tmpTypeText
            }
        }
        else if self.pickerOfType == "MonthPicker"
        {
            if self.txtExpirationMonth!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
            {
                self.txtExpirationMonth!.text = ""
            }
            else
            {
                self.txtExpirationMonth!.text = self.tmpTypeText
            }
        }
        else if self.pickerOfType == "YearPicker"
        {
            if self.txtExpirationYear!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
            {
                self.txtExpirationYear!.text = ""
            }
            else
            {
                self.txtExpirationYear!.text = self.tmpTypeText
            }
        }
                self.isPickerViewUp = false
    }

    @IBAction func toolBarDone()
    {
        hidePickerView()
        self.isPickerViewUp = false
        if self.pickerOfType == "CardType"
        {
            self.txtType!.text = self.selectedPickerItem
        }
        else if self.pickerOfType == "MonthPicker"
        {
            self.txtExpirationMonth!.text = self.selectedPickerItem
        }
        else if self.pickerOfType == "YearPicker"
        {
            self.txtExpirationYear!.text = self.selectedPickerItem
        }
        self.selectedPickerItem = ""
    }
    
    //Function to Get Up Card Type Picker view
    func getUpPickerView()
    {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations:
            {
                var rViewDatepicker = self.viewPicker!.frame as CGRect
                rViewDatepicker.origin.y = self.view.frame.size.height - 206
                self.viewPicker!.frame=rViewDatepicker
            },
            completion: {
                (finished: Bool) in
                self.lastTextField.resignFirstResponder()
                println("")
                self.pickerView!.selectRow(0, inComponent: 0, animated: true)
                self.selectedPickerItem = self.ArrayPickerItem.objectAtIndex(0) as String
            });
        self.pickerView!.delegate = self
    }
    //Function for Hide Card Type Picker View
    func hidePickerView()
    {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations:
            {
                var rViewDatepicker = self.viewPicker!.frame as CGRect
                rViewDatepicker.origin.y = self.view.frame.size.height + 1
                self.viewPicker!.frame=rViewDatepicker
            },
            completion: {
                (finished: Bool) in
                
            });
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
