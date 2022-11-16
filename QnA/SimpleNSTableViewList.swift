//
//  SimpleNSTableViewList.swift
//  BuildMenu
//
//  Created by Matt Hansen on 11/27/15.
//  Copyright © 2015 The Pennsylvania State University. All rights reserved.
//

import Cocoa

class SimpleNSTableViewList: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    internal var tableData = [[String: AnyObject]]()
    
    init(data: [[String: AnyObject]] = []) {
        tableData = data
    }
    
    func append(_ stringToAppend: [String: String]) -> Int{
        tableData.append(stringToAppend as [String : AnyObject])
        return tableData.count
    }
    
    func count() -> Int {
        return tableData.count
    }
    
    func removeAtIndex(_ indexToRemove: Int) {
        tableData.remove(at: indexToRemove)
    }
    
    func getIndexAndKeyAsString(_ index: Int, key: String) -> String{
        if index > tableData.count - 1 {
            return String("")
        } else {
            return tableData[index][key]! as! String
        }
    }
 
    //
    // MARK: - NSTableViewDataSource Functions
    //
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let object = tableData[row] as Dictionary
        return object[tableColumn!.identifier.rawValue]
    }

    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
        // Checkbox column of packages table requires Int values, all others are String
        if (tableView.identifier!.rawValue == "selected") {
            tableData[row][(tableColumn?.identifier.rawValue)!] = object! as? Int as AnyObject?
        } else {
            tableData[row][(tableColumn?.identifier.rawValue)!] = object! as? String as AnyObject?
        }
        print("Table View running")
        tableView.reloadData()
    }
    
}
