//
//  PendingNotification.swift
//  Local-Notification-Lab
//
//  Created by Gregory Keeley on 2/20/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import Foundation
import UserNotifications

class PendingNotification {
    public func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> ()) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            print("There are \(requests.count) pending requests")
            completion(requests)
        }
    }
}
