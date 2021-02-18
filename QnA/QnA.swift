    //
//  QnA.swift
//  QnA GUI
//
//  Created by Myers, Russell on 10/19/19.
//  Copyright © 2019 Rusty Myers. All rights reserved.
//
import Cocoa
import Foundation
import os
    
class QnA: NSObject {
    var qnaPath = String()
    //TODO make qna_file_paths a preference, ordered list of preference?
    var qna_file_paths:[String] = ["/Library/BESAgent/BESAgent.app/Contents/MacOS/QnA","QnA","/usr/local/bin/QnA"]
    
    func getQnAPath() -> String {
        // Create a FileManager instance
        let fileManager = FileManager.default
        
        // Check if file exists, given its path
        for qna_test_Path in qna_file_paths {
            // Example: http://stackoverflow.com/questions/30097521/messagebox-from-daemon-in-swift-os-x
            if fileManager.fileExists(atPath: qna_test_Path) {
                print("File exists: \(qna_test_Path)")
                self.qnaPath = qna_test_Path
                break
            } else {
                print("File not found: \(qna_test_Path)")
                self.qnaPath = ""
            }
        }
        if self.qnaPath == "" {
            let alert:NSAlert = NSAlert();
            alert.messageText = "Missing QnA Binary";
            alert.informativeText = "QnA GUI.app could not find the QnA binary! Please install and try again.";
            alert.runModal();
            exit(3)

        } 
        return self.qnaPath
    }
    
    func shell(relevance: String) -> String {
        let task = Process()
        let inpipe = Pipe()
        let outpipe = Pipe()
        
        //NSLog("%@", relevance)
        task.launchPath = getQnAPath()
        //TODO Make -showtypes a preference?
        task.arguments = ["-showtypes"]
        task.standardInput = inpipe
        task.standardOutput = outpipe

        inpipe.fileHandleForWriting.write(relevance.data(using: String.Encoding.utf8)!)
        inpipe.fileHandleForWriting.closeFile()
        
        task.launch()
        task.waitUntilExit()

        let outputdata = outpipe.fileHandleForReading.readDataToEndOfFile()
        let standardout = NSString(data: outputdata, encoding: String.Encoding.utf8.rawValue)
        
        return (standardout! as String)
    }
}
