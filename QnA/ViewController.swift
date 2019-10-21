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
    //this is the file. we will write to and read from it
    let tmpQueryFile = "/tmp/_qna_query.txt"
    
    override func viewDidDisappear() {
        // Remove the file when the app closes
        deleteFile()
    }
    override func viewDidLoad() {
        if #available(OSX 10.10, *) {
            super.viewDidLoad()
        } else {
            // Fallback on earlier versions
        }
        // Enable selection in query output window
        queryOut.isEditable = false
        // Set the tool top on the query button to qna binary path
        queryButtonOutlet.toolTip = appDelegate.qnaPath

        // Do any additional setup after loading the view.
        queryBar.stringValue = readFile()
    }

    func readFile() -> String {
        // https://stackoverflow.com/questions/37981375/nsfilehandle-updateatpath-how-can-i-update-file-instead-of-overwriting
        //https://developer.apple.com/documentation/foundation/filehandle/1411131-init
        // Turn our queryText string into data
//        let data = queryText.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        // Create new filemanager
        let filemanager = FileManager.default
        // Check for the file at the path and create if it doesn't exist
        if filemanager.fileExists(atPath: tmpQueryFile) == true {
            // Open the file for writing
            let fileHandle = FileHandle.init(forReadingAtPath: tmpQueryFile)
            // Write updated query string
            let fileData = fileHandle!.readDataToEndOfFile()
            let fileString = NSString(data: fileData, encoding: String.Encoding.utf8.rawValue)
            // Close file
            fileHandle!.closeFile()
            return fileString as! String
        } else {
            return ""
        }
        

    }
    func writeToFile(queryText: String) {
        // https://stackoverflow.com/questions/37981375/nsfilehandle-updateatpath-how-can-i-update-file-instead-of-overwriting
        //https://developer.apple.com/documentation/foundation/filehandle/1411131-init
        // Turn our queryText string into data
        let data = queryText.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        // Create new filemanager
        let filemanager = FileManager.default
        // Check for the file at the path and create if it doesn't exist
        if filemanager.fileExists(atPath: tmpQueryFile) == false {
            filemanager.createFile(atPath: tmpQueryFile, contents: data, attributes: nil)
        }
        // Open the file for writing
        let fileHandle = FileHandle.init(forWritingAtPath: tmpQueryFile)
        // Write updated query string
        fileHandle!.write(data)
        // Close file
        fileHandle!.closeFile()

    }
    
    func deleteFile() {
        //https://developer.apple.com/documentation/foundation/filemanager/1408573-removeitem
        // Create new filemanager
        let filemanager = FileManager.default
        // Check for file and delete it
        if filemanager.fileExists(atPath: tmpQueryFile) == true {
            return try! filemanager.removeItem(atPath: tmpQueryFile)
        }
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
        deleteFile()
        //NSLog("Output: %@", shelloutput)
        writeToFile(queryText: newQuery)
        
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
