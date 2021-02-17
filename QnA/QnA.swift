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
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    
    func getQnAPath() -> String {
        let qnaPath = appDelegate.qnaPath
        return qnaPath
    }
    
    func shell(relevance: String) -> String {
        let task = Process()
        let inpipe = Pipe()
        let outpipe = Pipe()
        
        //NSLog("%@", relevance)
        task.launchPath = getQnAPath()
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
