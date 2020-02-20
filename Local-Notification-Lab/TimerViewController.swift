//
//  ViewController.swift
//  Local-Notification-Lab
//
//  Created by Gregory Keeley on 2/20/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit



class TimerViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var titleTextField: UITextField!
    
    private var timeInterval: TimeInterval = Date().timeIntervalSinceNow
    
    private let center = UNUserNotificationCenter.current()
    private let pendingNotification = PendingNotification()
    
    private var hour: Double = 0
    private var minute: Double = 0
    private var second: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        center.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        timeInterval = 0
    }
    
    private func createLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = timeInterval.description
        content.subtitle = titleTextField.text ?? "No title"
        content.sound = .default
        let identifier = UUID().uuidString
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error adding request: \(error)")
            } else {
                print("Request was successfully added")
            }
        }
    }
    private func resetPickerView() {
        createLocalNotification()
        pickerView.selectRow(0, inComponent: 0, animated: true)
        hour = 0
        pickerView.selectRow(0, inComponent: 1, animated: true)
        minute = 0
        pickerView.selectRow(0, inComponent: 2, animated: true)
        second = 0
    }
    private func getTotalSecondsForTimer() {
        timeInterval = (hour * 60) * 60
        timeInterval = timeInterval + (minute * 60)
        timeInterval = timeInterval + second
    }
    @IBAction func setTimerButtonPressed() {
        guard timeInterval > 0 else { showAlert(title: "No time set", message: "Please select a time to create a timer"); return }
        checkForNotificationAuthorization()
        getTotalSecondsForTimer()
        resetPickerView()
        timeInterval = 0
    }
    private func checkForNotificationAuthorization() {
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                print("App is authorized for notifications")
            } else {
                self.requestNotificationPermissions()
            }
        }
    }
    private func requestNotificationPermissions() {
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print("error requesting authorization: \(error)")
                return
            }
            if granted {
                print("Access was granted")
            } else {
                print("Access denied")
            }
        }
    }

}
extension TimerViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}
extension TimerViewController: UIPickerViewDelegate {
    
}
extension TimerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 25
        case 1,2:
            return 60
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width / 3
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row) Hour"
        case 1:
            return "\(row) Minute"
        case 2:
            return "\(row) Seconds"
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            hour = Double(row)
        case 1:
            minute = Double(row)
        case 2:
            second = Double(row)
        default:
            return
        }
    }
}

extension UIViewController {
    func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: completion)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
