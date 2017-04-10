//
//  NotificationViewController.swift
//  ContentExtension
//
//  Created by Silvina Roldan on 3/14/17.
//  Copyright © 2017 Silvina Roldan. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
  
  @IBOutlet var imageView : UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.layer.cornerRadius = imageView.bounds.height/2.0
    imageView.layer.borderColor = UIColor.white.cgColor
    imageView.layer.borderWidth = 5
    imageView.layer.masksToBounds = true
  }
  
  func didReceive(_ notification: UNNotification) {
    guard let attachment = notification.request.content.attachments.first else {
      return
    }
    
    if attachment.url.startAccessingSecurityScopedResource() {
      do {
        let imageData = try Data.init(contentsOf: attachment.url)
        imageView.image = UIImage(data: imageData)
        attachment.url.stopAccessingSecurityScopedResource()
      } catch {
        print("Error accessing url content")
      }
    }
  }
}
