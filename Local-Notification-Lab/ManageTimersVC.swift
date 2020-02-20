//
//  ManagaTimersVC.swift
//  Local-Notification-Lab
//
//  Created by Gregory Keeley on 2/20/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit

protocol CreateNotificationDelegate: AnyObject {
    func didCreateNotification(_ TimerViewController: TimerViewController)
}

class ManageTimersVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var notifications = [UNNotificationRequest]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var refreshControl: UIRefreshControl!
    
    private let pendingNotification = PendingNotification()
    
    weak var delegate: CreateNotificationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadNotifications()
    }
    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadNotifications), for: .valueChanged)
    }
    @objc private func loadNotifications() {
        pendingNotification.getPendingNotifications { (requests) in
            self.notifications = requests
//            DispatchQueue.main.async {
//                self.refreshControl.endRefreshing()
//            }
        }
    }
}
extension ManageTimersVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timerCell", for: indexPath)
        let notification = notifications[indexPath.row]
        cell.textLabel?.text = ("Seconds: \(notification.content.title)")
        cell.detailTextLabel?.text = notification.content.subtitle
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeNotification(atIndexPath: indexPath)
        }
    }
    private func removeNotification(atIndexPath indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        notifications.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
}
extension ManageTimersVC: UITableViewDelegate {
    
}
