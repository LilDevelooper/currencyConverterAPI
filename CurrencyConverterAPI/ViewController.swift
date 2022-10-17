//
//  ViewController.swift
//  CurrencyConverterAPI
//
//  Created by yunus emre vural on 16.10.2022.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,
                      UITextFieldDelegate
{
    
    var list = [String]()
    
    @IBOutlet weak var dropDownList2: UIPickerView!
    @IBOutlet weak var dropDownList: UIPickerView!
    @IBOutlet weak var value1TextField: UITextField!
    @IBOutlet weak var value2Label: UILabel!
    @IBOutlet weak var currency1TextField: UITextField!
    @IBOutlet weak var currency2TextField: UITextField!
    
    var calculatedResult: Double?
    
    var selectedCurrency1 = ""
    var selectedCurrency2 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currency1TextField.isHidden = true
        currency2TextField.isHidden = true
        
        dropDownList.dataSource = self
        dropDownList.delegate = self
        
        dropDownList2.dataSource = self
        dropDownList2.delegate = self
        
        getCurrencyNames()
        
    }
    
    //dropListDown--> Begin
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)
    -> String?
    {
        
        //self.view.endEditing(true)
        return self.list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1{
            selectedCurrency1 = self.list[row]
        }else if pickerView.tag == 2 {
            selectedCurrency2 = self.list[row]
        }else{
            
        }
       // self.value2Label.text = self.list[row]
        //self.dropDownList.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.value2Label {
            self.dropDownList.isHidden = false
            //if you don't want the users to se the keyboard type:
            
            textField.endEditing(true)
        }
    }
    
    //DropDownList <-- End
    
    @IBAction func calculateButton(_ sender: Any) {
        
        // 1) Request & Session
        // 2) Response & Data
        // 3) Parsing & JSON Serialization
        
        //Check values must be a number from text fields.
        if value1TextField.text!.isDigits == true {
            
          
            
            let selectedCurrency = selectedCurrency1
            
            //1 Request and Session
            let url = URL(
                string:
                    "https://api.fastforex.io/fetch-all?from=\(selectedCurrency)&api_key=dab230415a-d855b8b482-rjuej9"
            )
            
            let session = URLSession.shared
            
            //Closure
            let task = session.dataTask(with: url!) { data, response, error in
                
                if data != nil {
                    
                    //2 Response and Data
                    do {
                        let jsonResponse =
                        try JSONSerialization.jsonObject(
                            with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        as! [String: Any]
                        
                        //ASYNC
                        
                        DispatchQueue.main.async {
                            
                            //3 Parse and Serialize
                            if let rates = jsonResponse["results"] as? [String: Any] {
                                
                                if let choosenCurrency1 = rates[self.selectedCurrency1] as? Double {
                                      if let choosenCurrency2 = rates[self.selectedCurrency2] as? Double {
                                          
                                          if let doubleValueOfValue1 = Double(self.value1TextField.text!) {
                                              
                                              self.calculatedResult =
                                              (doubleValueOfValue1 / choosenCurrency1) * choosenCurrency2
                                              
                                              self.calculatedResult =
                                              (doubleValueOfValue1 / choosenCurrency1) * choosenCurrency2
                                              
                                              self.value2Label.text = "\(self.calculatedResult!)"
                                              
                                          }
                                          
                                      }
                                  }
                                
                              /*  if let choosenCurrency1 = rates[self.currency1TextField.text!] as? Double {
                                    if let choosenCurrency2 = rates[self.currency2TextField.text!] as? Double {
                                        
                                        if let doubleValueOfValue1 = Double(self.value1TextField.text!) {
                                            
                                            self.calculatedResult =
                                            (doubleValueOfValue1 / choosenCurrency1) * choosenCurrency2
                                            
                                            self.calculatedResult =
                                            (doubleValueOfValue1 / choosenCurrency1) * choosenCurrency2
                                            
                                            self.value2Label.text = "\(self.calculatedResult!)"
                                            
                                        }
                                        
                                    }
                                } */
                                
                                // print(rates[self.currency1TextField.text!]!)
                            }
                            
                        }
                    } catch {
                        
                    }
                    
                }
                
            }
            
            task.resume()
            
        }else{
            alertPop(title: "Error", message: "Only Number")
        }
        
    }
    
    func alertPop(title: String, message: String) {
        
        let alert = UIAlertController(
            title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func getCurrencyNames() {
        
        let url = URL(string: "https://api.fastforex.io/fetch-all?api_key=dab230415a-d855b8b482-rjuej9")
        
        let session = URLSession.shared
        
        //Closure
        let task = session.dataTask(with: url!) { data, response, error in
            
            if data != nil {
                
                //2 Response and Data
                do {
                    
                    let jsonResponse =
                    try JSONSerialization.jsonObject(
                        with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    as! [String: Any]
                    
                    //3 Parse and Serialize
                    if let rates = jsonResponse["results"] as? [String: Any] {
                        
                        for (key, _) in rates {
                            
                            self.list.append(key)
                            
                        }
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                      
                        self.list.sort()
                        self.dropDownList.reloadAllComponents()
                        self.dropDownList2.reloadAllComponents()
                    }
                    
                } catch {
                    
                    print("error")
                    
                }
                
            }
            
        }
        
        task.resume()
        
    }
    
}

