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
    // Create new QnA object
    let qna = QnA.init()

    @IBOutlet weak var queryBar: NSTextField!
    @IBOutlet var queryOut: NSTextView!
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    @IBOutlet var queryButtonOutlet: NSButton!
    
    
    override func viewDidLoad() {
        if #available(OSX 10.10, *) {
            super.viewDidLoad()
        } else {
            // Fallback on earlier versions
        }
        queryOut.isEditable = false
        queryButtonOutlet.toolTip = appDelegate.qnaPath
    // Do any additional setup after loading the view.
    }
    
    @IBAction func clearOutput(sender: Bundle) {
        queryOut.textStorage?.mutableString.setString("")
    }


    @IBAction func queryButton(sender: AnyObject) {
        //NSLog("We've hit a button!")
        
        if queryBar.stringValue == "" {
            NSLog("Blank String")
            return
        }
        
        // Get unquoted string from text bar
        guard let newQuery:String = queryBar.stringValue else {
            return
        }
        // Log new string
        //NSLog("Sending query: %@", newQuery)
        
        // Add query to textbox
        setqueryOutput("Q: " + newQuery + "\n")
        
        // Send query to QnA Object and get output
        let shelloutput = qna.shell(relevance: newQuery)
        // Set text view to output
        setqueryOutput(shelloutput)
        
        //NSLog("Output: %@", shelloutput)

    }


    func shell(_ relevance: String) -> String {
        let task = Process()
        let inpipe = Pipe()
        let outpipe = Pipe()
        
        //NSLog("%@", relevance)
        let qnaPath = qna.getQnAPath()
        task.launchPath = qnaPath
        task.arguments = ["-showtypes"]
        task.standardInput = inpipe
        task.standardOutput = outpipe
        task.standardError = outpipe

        inpipe.fileHandleForWriting.write(relevance.data(using: String.Encoding.utf8)!)
        inpipe.fileHandleForWriting.closeFile()
        
        task.launch()
        // Disabled for large returns
        // task.waitUntilExit()
        
        let outputdata = outpipe.fileHandleForReading.readDataToEndOfFile()
        let standardout = NSString(data: outputdata, encoding: String.Encoding.utf8.rawValue)
        
        return (standardout! as String)
    }
    
    func setqueryOutput(_ text: String = "") {
        queryOut.textStorage?.mutableString.append(text)
        queryOut.scrollToEndOfDocument(self)
        queryOut.textColor = NSColor.controlTextColor
    }

}
