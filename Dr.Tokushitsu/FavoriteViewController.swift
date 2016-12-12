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
    
    //@IBOutlet var tableView: UITableView!
    
    var favList: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerUserDefaults()
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.backBarButtonItem = UIBarButtonItem(title:NSLocalizedString("Back", comment: "Back button of the navigation bar"),style: .plain, target: nil, action: nil)
    }
    
    func tabDidSelect() {
        getUserDefaults()
        tableView.reloadData()
    }
    
    func registerUserDefaults() {
        let userDefaults = UserDefaults.standard
        userDefaults.register(defaults: ["favList": []])
    }
    
    func getUserDefaults() {
        let userDefaults = UserDefaults.standard
        favList = userDefaults.object(forKey: "favList") as! [[String]]
    }
    
    func saveUserDefaults() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(favList, forKey: "favList")
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "FavoriteCell")
        if (favList.count > 0) {
            cell.textLabel?.text = favList[indexPath.row][1]
            cell.detailTextLabel?.text = favList[indexPath.row][0]
        }
        cell.detailTextLabel?.textColor = UIColor.gray
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier:"showDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let path = "mhlw/" + (NSString(format: "%03d", tableView.indexPathForSelectedRow!.row + 1) as String) + ".pdf"
        let viewer: PDFKBasicPDFViewer = segue.destination as! PDFKBasicPDFViewer
        let pdfPath = Bundle.main.path(forResource: path, ofType:nil)!
        let document = PDFKDocument(contentsOfFile: pdfPath, password: nil)
        viewer.loadDocument(document)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (tableView.indexPathForSelectedRow != nil) {
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true);
        }
    }
}
