//
//  SampleHandler.swift
//  Broadcast
//
//  Created by linjj on 2021/8/6.
//

import ReplayKit
import Alamofire

class SampleHandler: RPBroadcastSampleHandler {

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
//            guard let strongSelf = self else { return }
//            let error = NSError(domain: "SampleHandler", code: -1, userInfo: [NSLocalizedDescriptionKey: "description aaa"])
//            strongSelf.finishBroadcastWithError(error)
//        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        dateFormatter.string(from: Date())
        let fileName = "ScreenRecord_\(dateFormatter.string(from: Date())).mp4"
        
        guard var fileFolder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.newcunnar.ScreenRecordTest")?.path else {
            return
        }
        
        fileFolder = fileFolder + "/Library/Caches/video/"
        
        if !FileManager.default.fileExists(atPath: fileFolder) {
            try? FileManager.default.createDirectory(atPath: fileFolder, withIntermediateDirectories: true, attributes: nil)
        }
        let filePath = fileFolder + fileName
        
        SampleWriter.shared.filePath = filePath
        SampleWriter.shared.callBack = { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            
            case .success:
                break
            case .failure(let error):
                let error = NSError(domain: "SampleHandler", code: -1, userInfo: [NSLocalizedDescriptionKey: "writer init error: \(error)"])
                strongSelf.finishBroadcastWithError(error)
            }
        }
        
//        DispatchQueue.main.async {
//            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
//                let attr = try? FileManager.default.attributesOfItem(atPath: filePath)
//                if let size = attr?[.size] as? Int {
//                    print("cur size: \(size)")
//                }
//            }
//        }
        
//        SessionManager.default.request("https://www.baidu.com").response { (response) in
//            guard let data = response.data else { return }
//            print("\(String(data: data, encoding: .utf8))")
//        }
//        print("extension: \(FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.newcunnar.ScreenRecordTest.Broadcast"))")
    }
    
    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
    }
    
    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
    }
    
    override func broadcastFinished() {
        // User has requested to finish the broadcast.

            let condition = NSCondition()
            SampleWriter.shared.finishWriting { (error) in
                
                if let e = error {
                    print("\(e)")
                } else {
                    print("broadcastFinished success")
                }
                condition.signal()
            }
            condition.wait()
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case RPSampleBufferType.video:
            // Handle video sample buffer
            SampleWriter.shared.write(videoBuffer: sampleBuffer)
            break
        case RPSampleBufferType.audioApp:
            // Handle audio sample buffer for app audio
            SampleWriter.shared.write(audioBuffer: sampleBuffer, audioSource: .app)
            break
        case RPSampleBufferType.audioMic:
            // Handle audio sample buffer for mic audio
//            SampleWriter.shared.write(audioBuffer: sampleBuffer, audioSource: .mic)
            break
        @unknown default:
            // Handle other sample buffer types
            fatalError("Unknown type of sample buffer")
        }
    }
}
