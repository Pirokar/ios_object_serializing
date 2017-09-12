//
//  ViewController.swift
//  Persistence
//
//  Created by Владимир Рыбалка on 12/09/2017.
//  Copyright © 2017 Vladimir Rybalka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var lineFieilds: [UITextField]!

    override func viewDidLoad() {
        super.viewDidLoad()
        let fileUrl = dataFileUrl()
        if(FileManager.default.fileExists(atPath: fileUrl.path)) {
            if let array = NSArray(contentsOf: fileUrl) as? [String] {
                for i in 0..<array.count {
                    lineFieilds[i].text = array[i]
                }
            }
        }
        let app = UIApplication.shared
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(notification:)), name: Notification.Name.UIApplicationWillResignActive, object: app)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func applicationWillResignActive(notification: NSNotification) {
        let fileUrl = self.dataFileUrl()
        let array = (self.lineFieilds as NSArray).value(forKey: "text") as! NSArray
        array.write(to: fileUrl, atomically: true)
    }

    func dataFileUrl() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var url = URL(fileURLWithPath: "")
        url = urls.first!.appendingPathComponent("data.plist")
        
        return url
    }
}

