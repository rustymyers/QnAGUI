//
//  PrefsViewController.swift
//  QnA GUI
//
//  Created by Myers, Russell on 2/17/21.
//  Copyright © 2021 Rusty Myers. All rights reserved.
//

import Cocoa
import AppKit
import SystemConfiguration

class PrefsViewController: NSViewController {
    var qna_list = [""]
    @IBOutlet weak var QnAPaths_tableView: NSTableView!
    var QnAPaths_sourcepaths : SimpleNSTableViewList!
    
    @IBAction func QnAPath_removeRow(_ sender: Any) {
        print(sender)
        let selectedRow: Int = QnAPaths_tableView.selectedRow
        if selectedRow < 0 {
            print("No Selected Row!")
        } else {
            print("Remove Path!")
            print(selectedRow)
            QnAPaths_sourcepaths.removeAtIndex(selectedRow)
            QnAPaths_tableView.reloadData()
        }
    }
    @IBAction func QnAPath_addRow(_ sender: Any) {
        print("Add Path!")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self

        // Do view setup here.
        self.QnAPaths_sourcepaths = SimpleNSTableViewList()
        let qna = QnA.init()
        qna_list = qna.getQnAPaths()
//        var dict: [String: AnyObject] = [:]
        for path in qna_list.makeIterator() {
            let _result = self.QnAPaths_sourcepaths.append(["selected": path])
            print(_result)
        }
//        print(self.QnAPaths_sourcepaths!)
        QnAPaths_tableView.dataSource = self.QnAPaths_sourcepaths
        QnAPaths_tableView.reloadData()
    }
    override func viewWillAppear() {
            super.viewWillAppear()
            QnAPaths_tableView.reloadData()
        }
    func save() {
        qna_list.sort { (selected: String, path: String) -> Bool in
            if selected == "true" {
                return true
            }
            return false
        }
        var data = Data()
        do {
            try data = NSKeyedArchiver.archivedData(withRootObject: qna_list, requiringSecureCoding: false)
        } catch {
            exit(1)
        }
        UserDefaults.standard.set(data, forKey: "todoItems")
        NotificationCenter.default.post(name: NSNotification.Name("dataChanged"), object: nil)
    }
}
//extension ViewController: NSTableViewDataSource {
//    func numberOfRows(in tableView: NSTableView) -> Int {
//        print(qna.qna_file_paths.count)
//        print(qna.getQnAPaths())
//        return qna.getQnAPaths().count
//    }
//
//
//
//}

//extension ViewController: NSTableViewDelegate {
//    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        let currentPurchase = qna.qna_file_paths[row]
//        print(currentPurchase)
//        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "selectedColumn") {
//            print(currentPurchase)
//        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "pathID") {
//            print(currentPurchase)
//        } else {
//            print(currentPurchase)
//        }
//        return nil
//    }
//}
