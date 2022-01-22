//
//  AddRegistrationTableViewController.swift
//  AddRegistrationTableViewController
//
//  Created by Евгений Пашко on 12.11.2021.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailAdressTextField: UITextField!
    
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var ckeckInDatePiker: UIDatePicker!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDatePiker: UIDatePicker!
    
    @IBOutlet weak var numberOfAdultsLabel: UILabel!
    @IBOutlet weak var numberOfAdultsStepper: UIStepper!
    @IBOutlet weak var numberOfChildrenLabel: UILabel!
    @IBOutlet weak var numberOfChildrenStepper: UIStepper!
    @IBOutlet weak var wifiSwitcher: UISwitch!
    
    @IBOutlet weak var roomTypeLabel: UILabel!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    // MARK: - Properties
     private let checkInDateLabelIndexPath = IndexPath(row: 0, section: 1)
     private let checkInDatePikerIndexPath = IndexPath(row: 1, section: 1)
     private let checkOutDateLabelIndexPath = IndexPath(row: 2, section: 1)
     private let checkOutDatePikerIndexPath = IndexPath(row: 3, section: 1)
    
     private var isCheckInDatePikerShow: Bool = false {
        didSet {
            ckeckInDatePiker.isHidden = !isCheckInDatePikerShow
        }
    }
     private var isCheckOutDatePikerShow: Bool = false {
        didSet {
            checkOutDatePiker.isHidden = !isCheckOutDatePikerShow
        }
    }
    
     private var roomType: RoomType?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let midnightToday = Calendar.current.startOfDay(for: Date())
        ckeckInDatePiker.minimumDate = midnightToday
        ckeckInDatePiker.date = midnightToday
        doneButton.isEnabled = checkLabel()
        
        updateDataViews()
        updateNumberOfGuest()
        updateRoomType()
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         guard segue.identifier == "SelectRoomType" else { return }
         let destination = segue.destination as! SelectRoomTypeTableViewController
         destination.delegate = self
         destination.roomType = roomType
    }
    
    
    // MARK: - UI Methods
    // Check Labels isEmpty
     private func checkLabel() -> Bool{
        if !(firstNameTextField.text!.isEmpty ||
            lastNameTextField.text!.isEmpty) {
            return true
        } else {
            return false
        }
    }
    
    // Show alert message
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "I realized", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func updateDataViews() {
        checkOutDatePiker.minimumDate = ckeckInDatePiker.date.addingTimeInterval(60 * 60 * 24)
        
        let dateFormated = DateFormatter()
        dateFormated.dateStyle = .medium
        dateFormated.locale = Locale.current
        
        checkInDateLabel.text = dateFormated.string(from: ckeckInDatePiker.date)
        checkOutDateLabel.text = dateFormated.string(from: checkOutDatePiker.date)
    }
    
    private func updateNumberOfGuest() {
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        numberOfAdultsLabel.text = "\(numberOfAdults)"
        numberOfChildrenLabel.text = "\(numberOfChildren)"
    }
    
    private func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
        } else {
            roomTypeLabel.text = "Not Set"
        }
        
    }
    
    
    // MARK: - IBActions
    @IBAction func datePikerValueChangen(_ sender: UIDatePicker) {
        updateDataViews()
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        // Check romeType for nil
        guard roomType.self != nil else {
            showAlert(title: "Room Type", message: "Choose Roome Type please!")
            roomTypeLabel.textColor = .red
            return
        }

        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailAdressTextField.text ?? ""
        let checkInDate = ckeckInDatePiker.date
        let checkOutDate = checkOutDatePiker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let wifi = wifiSwitcher.isOn
        
        let registration = Registration(
            firstName: firstName,
            lastName: lastName,
            emailAdress: email,
            checkInDate: checkInDate,
            checkOutData: checkOutDate,
            numberOfAdults: numberOfAdults,
            numberOfChildren: numberOfChildren,
            roomType: roomType,
            wifi: wifi)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuest()
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        doneButton.isEnabled = checkLabel()
    }
    
}

extension AddRegistrationTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
            
            //  Set 0.01 because with 0 not working correctly.
        case checkInDatePikerIndexPath:
            return isCheckInDatePikerShow ? UITableView.automaticDimension : 0.01
        case checkOutDatePikerIndexPath:
            return isCheckOutDatePikerShow ? UITableView.automaticDimension : 0.01
        default:
            return UITableView.automaticDimension
        }
    }
}

extension AddRegistrationTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case checkInDateLabelIndexPath:
            isCheckInDatePikerShow.toggle()
            isCheckOutDatePikerShow = false
        case checkOutDateLabelIndexPath:
            isCheckOutDatePikerShow.toggle()
            isCheckInDatePikerShow = false
        default:
            return
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension AddRegistrationTableViewController: SelectRoomTypeTableViewControllerProtocol {
    func didSelect(roomType: RoomType) {
        self.roomType = roomType
        roomTypeLabel.textColor = .black
        updateRoomType()
    }
}



