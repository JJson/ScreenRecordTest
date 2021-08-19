//
//  ViewController.swift
//  ScreenRecordTest
//
//  Created by linjj on 2021/8/6.
//

import UIKit
import ReplayKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 录屏
        if #available(iOS 12.0, *) {
            let broadcastPicker = RPSystemBroadcastPickerView(frame: CGRect(x: 120, y: 120, width: 100, height: 100))
            broadcastPicker.preferredExtension = "com.newcunnar.ScreenRecordTest.Broadcast"
            broadcastPicker.showsMicrophoneButton = false
            view.addSubview(broadcastPicker)
        } else {
            // Fallback on earlier versions
        }
//        SessionManager.default.request("https://www.baidu.com").response { (response) in
//            guard let data = response.data else { return }
//            print("\(String(data: data, encoding: .utf8))")
//        }
//        print("contain app: \(FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.newcunnar.ScreenRecordTest.Broadcast"))")
        
        
    }

    @IBAction func moveFileToDocument() {
        guard var fileFolder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.newcunnar.ScreenRecordTest")?.path else {
            return
        }
        fileFolder = fileFolder + "/Library/Caches/video/"
        let fileNames = try? FileManager.default.contentsOfDirectory(atPath: fileFolder)
        fileNames?.forEach({ (fileName) in
            let filePath = fileFolder + fileName
            let newPath = NSHomeDirectory() + "/Documents/\(fileName)"
            try? FileManager.default.moveItem(atPath: filePath, toPath: newPath)
        })
    }
    
    @IBAction func showFiles() {
        guard var fileFolder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.newcunnar.ScreenRecordTest")?.path else {
            return
        }
        fileFolder = fileFolder + "/Library/Caches/video/"
        let files = try? FileManager.default.contentsOfDirectory(atPath: fileFolder).map({ (fileName) -> [String: Int] in
            let path = fileFolder + fileName
            var fileSize = -1
            
            let attr = try? FileManager.default.attributesOfItem(atPath: path)
            if let size = attr?[.size] as? Int {
                fileSize = size
            }
            return [fileName: fileSize]
            
        })
        print("files: \(files)")
    }
    
    
}


