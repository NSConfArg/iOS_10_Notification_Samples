//
//  NotificationService.swift
//  ServiceExtension
//
//  Created by Silvina Roldan on 3/7/17.
//  Copyright © 2017 Silvina Roldan. All rights reserved.
//

import UserNotifications
import MobileCoreServices

class NotificationService: UNNotificationServiceExtension {
  
  var contentHandler: ((UNNotificationContent) -> Void)?
  var bestAttemptContent: UNMutableNotificationContent?
  
  override func didReceive(_ request: UNNotificationRequest,
                           withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    self.contentHandler = contentHandler
    
    bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
    
    if let bestAttemptContent = bestAttemptContent {
      
      if let attachmentString = bestAttemptContent.userInfo["attachment-url"] as? String,
        let attachmentURL = URL(string:attachmentString) {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let downloadTask = session.downloadTask(with: attachmentURL,
          completionHandler: { (url, _ , error) in
            if let error = error {
              print("Error downloading attachment \(error.localizedDescription)")
            } else if let url = url {
              let attachment = try! UNNotificationAttachment(identifier: attachmentString,
                                                             url: url, options: [UNNotificationAttachmentOptionsTypeHintKey : kUTTypePNG])
              bestAttemptContent.attachments = [attachment]
              bestAttemptContent.categoryIdentifier = "myNotificationCategory"
            }
            contentHandler(bestAttemptContent)
        })
        downloadTask.resume()
      }
    }
  }
  
  override func serviceExtensionTimeWillExpire() {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
      contentHandler(bestAttemptContent)
    }
  }
  
}
