//
//  AppDelegate.swift
//  QnA
//
//  Created by Rusty Myers on 3/9/16.
//  Copyright © 2016 Rusty Myers. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var runQueryMenuItem: NSMenuItem!
    
    var qnaPath = String()
    var qna_file_paths:[String] = ["/Library/BESAgent/BESAgent.app/Contents/MacOS/QnA","QnA","/usr/local/bin/QnA"]

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        NSLog("Starting App")
        
        // Create a FileManager instance
        let fileManager = FileManager.default
        
        // Check if file exists, given its path
        for qna_test_Path in qna_file_paths {
            // Example: http://stackoverflow.com/questions/30097521/messagebox-from-daemon-in-swift-os-x
            if fileManager.fileExists(atPath: qna_test_Path) {
                print("File exists: \(qna_test_Path)")
                qnaPath = qna_test_Path
                return
            } else {
                print("File not found: \(qna_test_Path)")
            }
        }
        if qnaPath == "" {
            let alert:NSAlert = NSAlert();
            alert.messageText = "Missing QnA Binary";
            alert.informativeText = "QnA GUI.app could not find the QnA binary! Please install and try again.";
            alert.runModal();
            exit(3)

        } else {
            print("We found qna! \(qnaPath)")
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // Quit the application when the window is closed
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

