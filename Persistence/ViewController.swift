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
    private static let rootKey = "rootKey"

    override func viewDidLoad() {
        super.viewDidLoad()
        let fileUrl = dataFileUrl()
        if(FileManager.default.fileExists(atPath: fileUrl.path)) {
            if let array = NSArray(contentsOf: fileUrl) as? [String] {
                for i in 0..<array.count {
                    lineFieilds[i].text = array[i]
                }
            }
            let data = NSMutableData(contentsOf: fileUrl)
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data! as Data)
            let fourLines = unarchiver.decodeObject(forKey: ViewController.rootKey) as! FourLines
            unarchiver.finishDecoding()
            
            if let newLines = fourLines.lines {
                for i in 0..<newLines.count {
                    lineFieilds[i].text = newLines[i]
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
        let fourLines = FourLines()
        let array = (self.lineFieilds as NSArray).value(forKey: "text") as! [String]
        fourLines.lines = array
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(fourLines, forKey: ViewController.rootKey)
        archiver.finishEncoding()
        data.write(to: fileUrl, atomically: true)
    }

    func dataFileUrl() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var url = URL(fileURLWithPath: "")
        url = urls.first!.appendingPathComponent("data.archive")
        
        return url
    }
}

