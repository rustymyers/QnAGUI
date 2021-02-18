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
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    lazy var window: NSWindow! = self.view.window
    
    @IBAction func runQueryMenuItemSelected(_ sender: Any) {
        queryButton(sender: appDelegate)
    }
    @IBAction func clearOutputMenuItemSelected(_ sender: Bundle) {
        clearOutput(sender: sender)
    }
    @IBOutlet weak var queryBar: NSTextField!
    @IBOutlet var queryOut: NSTextView!
    @IBOutlet var queryButtonOutlet: NSButton!

    //this is the file. we will write to and read from it
    let tmpQueryFile = "/tmp/_qna_query.txt"
    
    override func viewDidDisappear() {
        // Remove the file when the app closes
        deleteFile()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable selection in query output window
        queryOut.isEditable = false
        
        // Do any additional setup after loading the view.
        queryBar.stringValue = readFile()

    }

    override func viewWillAppear() {
            super.viewWillAppear()
            let qnaPath = qna.getQnAPath()
            window?.title = "QnA GUI (\(qnaPath))"
            // Set the tool top on the query button to qna binary path
            if queryButtonOutlet.toolTip != nil {
                queryButtonOutlet.toolTip = qnaPath
            } else {
                NSLog("Can't set tooltip")
            }
        }
    
    func readFile() -> String {
        // https://stackoverflow.com/questions/37981375/nsfilehandle-updateatpath-how-can-i-update-file-instead-of-overwriting
        //https://developer.apple.com/documentation/foundation/filehandle/1411131-init
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
            return fileString! as String
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
        let newQuery:String = queryBar.stringValue
        
        // Log new string
        NSLog("Sending query: %@", newQuery)
        
        // Remove temp file
        deleteFile()
        
        // Write query to temp file
        writeToFile(queryText: newQuery)
        
        // Add query to textbox
        setqueryOutput("Q: " + newQuery + "\n")
        
        // Send query to QnA Object and get output
        let shelloutput = qna.shell(relevance: newQuery)
        
        // Set text view to output
        setqueryOutput(shelloutput)
    }

    func setqueryOutput(_ text: String = "") {
        queryOut.textStorage?.mutableString.append(text)
        queryOut.scrollToEndOfDocument(self)
        queryOut.textColor = NSColor.controlTextColor
    }

}
