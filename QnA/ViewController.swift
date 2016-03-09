//
//  ViewController.swift
//  QnA
//
//  Created by Rusty Myers on 3/9/16.
//  Copyright © 2016 Rusty Myers. All rights reserved.
//
// Icons generated from BigFix Logo using https://makeappicon.com/

import Cocoa
import Foundation

class ViewController: NSViewController {
    var qnaPath = "/Library/BESAgent/BESAgent.app/Contents/MacOS/QnA"
    
    @IBOutlet weak var queryBar: NSTextField!
    @IBOutlet var queryOut: NSTextView!
    
    override func viewDidLoad() {
        if #available(OSX 10.10, *) {
            super.viewDidLoad()
        } else {
            // Fallback on earlier versions
        }
        queryOut.editable = false

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func queryButton(sender: AnyObject) {
        // NSLog("We've hit a button!")
        if queryBar.stringValue == "" {
            NSLog("Blank String")
            return
        }
        
        // Get unquoted string from text bar
        guard let newQuery:String = queryBar.stringValue else {
            return
        }
        // Log new string
        NSLog("Sending query: %@", newQuery)
        
        // Wrap in single quotes
        let newCommand = ("\'" + newQuery + "\'" )
        // Log new string
        NSLog("New Command: %@", newCommand)
        
        // Add query to textbox
        setqueryOutput("Q: " + newQuery + "\n")
        
        // Send query to shell and get output
        let (shelloutput, _) = shell("/bin/bash", "-c", "echo " + newCommand + " | " + qnaPath)
        // Set text view to output
        setqueryOutput(shelloutput)
        
        NSLog("output: %@", shelloutput)

    }

    func shell(args: String...) -> (String, Int32) {
        let task = NSTask()
        let pipe = NSPipe()
        
        NSLog("%@", args)
        
        task.launchPath = args[0]
        task.arguments = Array(args[1..<args.count])
        task.standardOutput = pipe
        
        task.launch()
        task.waitUntilExit()
        
        let outputdata = pipe.fileHandleForReading.readDataToEndOfFile()
        let standardout = NSString(data: outputdata, encoding: NSUTF8StringEncoding)
        
        //return (standardout as! String)
        return (standardout as! String, task.terminationStatus)
    }
    
    func setqueryOutput(text: String = "") {
        queryOut.textStorage?.mutableString.appendString(text)
        queryOut.scrollToEndOfDocument(self)
    }

    
}

