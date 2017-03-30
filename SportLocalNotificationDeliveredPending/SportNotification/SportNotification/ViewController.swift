//
//  ViewController.swift
//  SportNotification
//
//  Created by Silvina Roldan on 3/10/17.
//  Copyright © 2017 Silvina Roldan. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate, UITableViewDataSource, UITableViewDelegate {
  
  var sections = ["Pending Notifications", "Delivered Notifications"]
  var notifications = [UNNotification]()
  var requests = [UNNotificationRequest]()
  var pressed = 0
  
  @IBOutlet weak var tableView: UITableView!
  var isGrantedNotificationAccess = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    UNUserNotificationCenter.current().requestAuthorization(
      options: [.alert,.sound,.badge],
      completionHandler: { (granted,error) in
        self.isGrantedNotificationAccess = granted
        if !granted{
          //add alert to complain
        }
    })
    UNUserNotificationCenter.current().delegate = self
  }
  
  @IBAction func listNotification(_ sender: UIButton) {
    loadNotificationData()
  }
  
  func loadNotificationData() {
    let group = DispatchGroup()
    
    let notificationCenter = UNUserNotificationCenter.current()
    let dataSaveQueue = DispatchQueue(label:
      "com.silvinaroldan.SportNotification.dataSave")
    
    group.enter()
    notificationCenter.getPendingNotificationRequests { (requests) in
      dataSaveQueue.async(execute: {
        self.requests = requests
        group.leave()
      })
    }
    
    group.enter()
    notificationCenter.getDeliveredNotifications { (notifications) in
      dataSaveQueue.async(execute: {
        self.notifications = notifications
        group.leave()
      })
    }
    
    group.notify(queue: DispatchQueue.main) {
        self.tableView.reloadData()
    }
  }
  
  @IBAction func RemoveNotifications(_ sender: UIButton) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["sport_notification"])
  }
  
  @IBAction func scheduleNotification(_ sender: UIButton) {
    
    let content = UNMutableNotificationContent()
    content.title = "Gol de Colon!!"
    pressed += 1
    content.body = "Colon \(pressed) - Union 0"
    content.categoryIdentifier = "sport_notification"
    
    let image = "gol"
    guard let imageURL = Bundle.main.url(forResource: image, withExtension: "gif") else {
      return
    }
    
    let attachment = try! UNNotificationAttachment(identifier: "gol", url: imageURL, options: .none)
    content.attachments = [attachment]
    
    let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.01,                                                        repeats: false)
    
    let request = UNNotificationRequest(identifier: "sport_notification", content: content, trigger: notificationTrigger
    )
    
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return requests.count
    } else {
      return notifications.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    if(indexPath.section == 0) {
      cell.textLabel?.text = self.requests[indexPath.row].content.title + " - " + self.requests[indexPath.row].content.body
    } else {
      cell.textLabel?.text = self.notifications[indexPath.row].request.content.title + " - " + self.notifications[indexPath.row].request.content.body
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section]
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    loadNotificationData()
    completionHandler(.alert)
  }
}

