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
    
    @IBAction func clearOutput(sender: NSBundle) {
        queryOut.textStorage?.mutableString.setString("")
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
        
        // Add query to textbox
        setqueryOutput("Q: " + newQuery + "\n")
        
        // Send query to shell and get output
        let shelloutput = shell(newQuery)
        // Set text view to output
        setqueryOutput(shelloutput)
        
        NSLog("Output: %@", shelloutput)

    }

    func shell(relevance: String) -> String {
        let task = NSTask()
        let inpipe = NSPipe()
        let outpipe = NSPipe()
        
        //NSLog("%@", relevance)
        
        task.launchPath = qnaPath
        task.standardInput = inpipe
        task.standardOutput = outpipe

        inpipe.fileHandleForWriting.writeData(relevance.dataUsingEncoding(NSUTF8StringEncoding)!)
        inpipe.fileHandleForWriting.closeFile()
        
        task.launch()
        task.waitUntilExit()

        let outputdata = outpipe.fileHandleForReading.readDataToEndOfFile()
        let standardout = NSString(data: outputdata, encoding: NSUTF8StringEncoding)
        
        return (standardout as! String)
    }
    
    func setqueryOutput(text: String = "") {
        queryOut.textStorage?.mutableString.appendString(text)
        queryOut.scrollToEndOfDocument(self)
    }

    
}

