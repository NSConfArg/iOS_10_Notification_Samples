//
//  ViewController.swift
//  BirthdayNotification
//
//  Created by Silvina Roldan on 6/2/17.
//  Copyright © 2017 Silvina Roldan. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler:{ (granted, error) in
      if granted {
        print("Notifications access granted")
      } else {
        if let error = error {
          print("Error: \(error.localizedDescription)")
        }
      }
    })
  }
  
  @IBAction func notifyButton (sender:UIButton) {
    scheduleNotification(inSeconds: 3) { success in
      if success {
        print("Successfully scheduled")
      } else {
        print("Error scheduling notification")
      }
    }
  }
  
  func scheduleNotification(inSeconds: TimeInterval, completion:@escaping (_ Success: Bool) -> ()) {
    
    let image = "you_are_invited"
    guard let imageURL = Bundle.main.url(forResource: image, withExtension: "png") else {
      completion(false)
      return
    }
    do {
      let attachment = try UNNotificationAttachment(identifier: "invitation", url: imageURL, options: .none)
      let notification = UNMutableNotificationContent()
      notification.title = "Come to my Birthday"
      notification.subtitle = "It will be a great party"
      notification.body = "04/23 at 10:00 PM"
      notification.attachments = [attachment]
      
      notification.categoryIdentifier = "myNotificationCategory"
      
      let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
      
      let request = UNNotificationRequest(identifier: "birthdayInvitation", content: notification, trigger: notificationTrigger)
      
      UNUserNotificationCenter.current().add(request) { (error) in
        if let error = error {
          print("Error: \(error.localizedDescription)")
          completion(false)
        } else {
          completion(true)
        }
      }
    } catch {
      print("Error adding attachment")
    }
  }
  
}

