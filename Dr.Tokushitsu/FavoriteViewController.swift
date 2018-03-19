//
//  FavoriteTableViewController.swift
//  Dr.Tokushitsu
//
//  Created by subdiox on 2016/12/12.
//  Copyright © 2016年 com.godcoderx. All rights reserved.
//

import UIKit
import M13PDFKit

class FavoriteViewController: UITableViewController {
    
    var favList: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.backBarButtonItem = UIBarButtonItem(title:NSLocalizedString("Back", comment: "Back button of the navigation bar"),style: .plain, target: nil, action: nil)
        getUserDefaults()
    }
    
    func getUserDefaults() {
        let userDefaults = UserDefaults.standard
        favList = userDefaults.object(forKey: "favList") as! [[String]]
    }
    
    func saveUserDefaults() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(favList, forKey: "favList")
        userDefaults.synchronize()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        favList.remove(at: indexPath.row)
        saveUserDefaults()
        tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: UITableViewRowAnimation.fade)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getUserDefaults()
        return favList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "FavoriteCell")
        cell.textLabel?.text = favList[indexPath.row][2]
        cell.detailTextLabel?.text = favList[indexPath.row][1]
        cell.detailTextLabel?.textColor = UIColor.gray
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier:"showDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let path = "mhlw/" + favList[tableView.indexPathForSelectedRow!.row][0] + ".pdf"
        let viewer: PDFViewController = segue.destination as! PDFViewController
        viewer.title = favList[tableView.indexPathForSelectedRow!.row][2]
        let pdfPath = Bundle.main.path(forResource: path, ofType:nil)!
        let document = PDFKDocument(contentsOfFile: pdfPath, password: nil)
        viewer.loadDocument(document)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        NSLog("source: %d, target: %d", fromIndexPath.row, toIndexPath.row)
        let from: [String] = favList[fromIndexPath.row]
        let to: [String] = favList[toIndexPath.row]
        favList[fromIndexPath.row] = to
        favList[toIndexPath.row] = from
        saveUserDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
        if (tableView.indexPathForSelectedRow != nil) {
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true);
        }
    }
}
