//
//  ContactDetailViewController.swift
//  Touchpoint
//
//  Created by user132895 on 1/8/18.
//  Copyright © 2018 TouchPoint. All rights reserved.
//

import UIKit
import os.log



class ContactDetailViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var orgTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var textMsgTextField: UITextField!
    @IBOutlet weak var addressStreetTextField: UITextField!
    @IBOutlet weak var addressCityTextField: UITextField!
    @IBOutlet weak var addressProvStateTextField: UITextField!
    @IBOutlet weak var addressCodeTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var frequencyTextField: UITextField!
    @IBOutlet weak var lastTPDateTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBAction func increaseFrequencyButton(_ sender: UIButton) {
        if frequencyTextField.text == "Quarterly" {
            frequencyTextField.text = "Monthly"
        }
        else if frequencyTextField.text == "Semiannually" {
            frequencyTextField.text = "Quarterly"
        }
        else if frequencyTextField.text == "Annually" {
            frequencyTextField.text = "Semiannually"
        }
    }
    @IBAction func decreaseFrequencyButton(_ sender: UIButton) {
        if frequencyTextField.text == "Quarterly" {
            frequencyTextField.text = "Semiannually"
        }
        else if frequencyTextField.text == "Monthly" {
            frequencyTextField.text = "Quarterly"
        }
        else if frequencyTextField.text == "Semiannally" {
            frequencyTextField.text = "Annually"
        }
    }
    
    @IBOutlet weak var lastTPBkgnd: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    /*
        This value is either passed by 'ContactTableViewController' in 'prepare(for:sender:)'
        or constructed as part of adding a new meal
    */
    var contact: Contact?
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field user input through delegate callbacks.
        nameTextField.delegate = self
        orgTextField.delegate = self
        phoneTextField.delegate = self
        textMsgTextField.delegate = self
        addressStreetTextField.delegate = self
        addressCityTextField.delegate = self
        addressProvStateTextField.delegate = self
        addressCodeTextField.delegate = self
        emailTextField.delegate = self
        frequencyTextField.delegate = self
        lastTPDateTextField.delegate = self
        birthdayTextField.delegate = self
        noteTextField.delegate = self
        
        createDatePicker()
        
        // Set up views if editing an existing contact
        if let contact = contact {
            navigationItem.title = "Contact Details"
            nameTextField.text = contact.name
            orgTextField.text = contact.org
            phoneTextField.text = contact.phone
            textMsgTextField.text = contact.textMsg
            addressStreetTextField.text = contact.addressStreet
            addressCityTextField.text = contact.addressCity
            addressProvStateTextField.text = contact.addressProvState
            addressCodeTextField.text = contact.addressCode
            emailTextField.text = contact.email
            frequencyTextField.text = contact.frequency
            lastTPDateTextField.text = contact.lastTPDate
            birthdayTextField.text = contact.birthday
            noteTextField.text = contact.note
        }
        
        lastTPBkgnd.backgroundColor = UIColor.red
        lastTPBkgnd.layer.cornerRadius = 10
        
        // Enable the save button only if the text field has a valid contact name
        updateSaveButtonState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = "New Contact"
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the save button when editing
        saveButton.isEnabled = false
    }
    
    //MARK: Date Picker for Birthday
    
    let datePicker = UIDatePicker()
    
    func createDatePicker () {
        // format date
        datePicker.datePickerMode = .date
        
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(birthdayDateDonePressed))
        toolbar.setItems([doneButton], animated: false)
        
        birthdayTextField.inputAccessoryView = toolbar
        
        // assigning date picker to text field
        birthdayTextField.inputView = datePicker
    }
    
    @objc func birthdayDateDonePressed() {
        // format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        birthdayTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push), this view controller needs to be dismissed in two different ways.
        print("The cancel button was pressed")
        let isPresentinginAddContactMode = presentingViewController != nil
        if isPresentinginAddContactMode {
            print("The cancel button was pressed in add contact mode")
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            print("The cancel button was pressed in edit contact mode")
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ContactDetailViewController is not inside a navigation controller")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let org = orgTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let textMsg = textMsgTextField.text ?? ""
        let addressStreet = addressStreetTextField.text ?? ""
        let addressCity = addressCityTextField.text ?? ""
        let addressProvState = addressProvStateTextField.text ?? ""
        let addressCode = addressCodeTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let frequency = frequencyTextField.text ?? ""
        let lastTPDate = lastTPDateTextField.text ?? ""
        let birthday = birthdayTextField.text ?? ""
        let note = noteTextField.text ?? ""
      
        
        // Set the contact to be passed to ContactTableViewController after the unwind segue.
        contact = Contact(name: name, org: org, phone: phone, textMsg: textMsg, addressStreet: addressStreet, addressCity: addressCity, addressProvState: addressProvState, addressCode: addressCode, email: email, frequency: frequency, lastTPDate: lastTPDate, birthday: birthday, note: note)
    }
    
    //MARK: Actions

    

    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

