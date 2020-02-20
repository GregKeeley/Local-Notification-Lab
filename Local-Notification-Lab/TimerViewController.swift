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
    
    private var hour: Double = 0
    private var minute: Double = 0
    private var second: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        timeInterval = 0
    }
    private func createLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = titleTextField.text ?? "No title"
        content.subtitle = "Timer"
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
        pickerView.selectRow(0, inComponent: 0, animated: true)
        hour = 0
        pickerView.selectRow(0, inComponent: 1, animated: true)
        minute = 0
        pickerView.selectRow(0, inComponent: 2, animated: true)
        second = 0
    }
    private func getTotalSecondsForTimer() {
        timeInterval = timeInterval + (hour * 60) * 60
        timeInterval = timeInterval + (minute * 60)
        timeInterval = timeInterval + second
    }
    @IBAction func setTimerButtonPressed() {
        getTotalSecondsForTimer()
        resetPickerView()
        print(timeInterval)
        timeInterval = 0
        print(timeInterval)
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
