//
//  NotificationViewController.swift
//  BirthdayContentExtension
//
//  Created by Silvina Roldan on 2/8/17.
//  Copyright © 2017 Silvina Roldan. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

  @IBOutlet var imageView: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didReceive(_ notification: UNNotification) {
      guard let attachment = notification.request.content.attachments.first else {
        return
      }
      
      if attachment.url.startAccessingSecurityScopedResource() {
        let imageData = try? Data.init(contentsOf: attachment.url)
        if let img = imageData {
          imageView.image = UIImage(data: img)
        }
      }
    }
  
//  func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
//    if response.actionIdentifier == "notGoing" {
//      completion(.dismissAndForwardAction)
//    } else {
//      completion(.dismiss)
//    }
//    
//  }

}
