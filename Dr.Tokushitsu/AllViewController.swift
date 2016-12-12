//
//  AllTableViewController.swift
//  Dr.Tokushitsu
//
//  Created by subdiox on 2016/12/12.
//  Copyright © 2016年 com.godcoderx. All rights reserved.
//

import UIKit
import M13PDFKit

class AllViewController : UITableViewController {
    
    //@IBOutlet var tableView: UITableView!
    
    var list: [[String]] = []
    var favList: [[String]] = []
    var viewer: PDFKBasicPDFViewer? = nil
    var lastIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerUserDefaults()
        navigationItem.backBarButtonItem = UIBarButtonItem(title:NSLocalizedString("Back", comment: "Back button of the navigation bar"),style: .plain, target: nil, action: nil)
        getUserDefaults()
        if let csvPath = Bundle.main.path(forResource: "list", ofType: "csv") {
            let csvString = try! NSString(contentsOfFile: csvPath, encoding: String.Encoding.utf8.rawValue)
            csvString.enumerateLines { (line, stop) -> () in
                self.list.append(line.components(separatedBy: ","))
            }
        }
    }
    
    func tabDidSelect() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "AllCell")
        cell.textLabel?.text = list[indexPath.row][1]
        cell.detailTextLabel?.text = list[indexPath.row][0]
        cell.detailTextLabel?.textColor = UIColor.gray
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastIndexPath = indexPath
        performSegue(withIdentifier:"showDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let path = "mhlw/" + (NSString(format: "%03d", tableView.indexPathForSelectedRow!.row + 1) as String) + ".pdf"
        let viewer: PDFKBasicPDFViewer = segue.destination as! PDFKBasicPDFViewer
        viewer.title = list[tableView.indexPathForSelectedRow!.row][1]
        let button = UIButton(type: UIButtonType.custom) as UIButton
        button.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30))
        button.setImage(UIImage(named: "star.png"), for: UIControlState.normal)
        button.setBackgroundImage(UIImage(named: "starfilled.png"), for: UIControlState.selected)
        button.addTarget(self, action: #selector(self.favorite), for: UIControlEvents.touchUpInside)
        viewer.navigationItem.setRightBarButton(UIBarButtonItem(customView:button), animated: true)
        let pdfPath = Bundle.main.path(forResource: path, ofType:nil)!
        let document = PDFKDocument(contentsOfFile: pdfPath, password: nil)
        viewer.loadDocument(document)
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
    
    func favorite(sender: UIButton) {
        if let indexPath = lastIndexPath {
            let i = favList.index { $0 == list[indexPath.row] }
            if (i == nil) {
                favList.append(list[lastIndexPath!.row])
                sender.isSelected = true
            } else {
                favList.remove(at:i!)
                sender.isSelected = false
            }
            saveUserDefaults()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (tableView.indexPathForSelectedRow != nil) {
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true);
        }
    }
}
