//
//  AllTableViewController.swift
//  Dr.Tokushitsu
//
//  Created by subdiox on 2016/12/12.
//  Copyright © 2016年 com.godcoderx. All rights reserved.
//

import UIKit
import M13PDFKit

class AllViewController : UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    
    var list: [[String]] = []
    var searchResult: [[String]] = []
    var favList: [[String]] = []
    var lastIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerUserDefaults()
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title:NSLocalizedString("Back", comment: "Back button of the navigation bar"),style: .plain, target: nil, action: nil)
        getUserDefaults()
        if let csvPath = Bundle.main.path(forResource: "list", ofType: "csv") {
            let csvString = try! NSString(contentsOfFile: csvPath, encoding: String.Encoding.utf8.rawValue)
            csvString.enumerateLines { (line, stop) -> () in
                self.list.append(line.components(separatedBy: ","))
            }
        }
        searchResult = list
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchResult.removeAll()
        if(searchBar.text == "") {
            searchResult = list
        } else {
            for data in list {
                if data[2].contains(searchBar.text!) {
                    searchResult.append(data)
                }
            }
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "AllCell")
        cell.textLabel?.text = searchResult[indexPath.row][2]
        cell.detailTextLabel?.text = searchResult[indexPath.row][1]
        cell.detailTextLabel?.textColor = UIColor.gray
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastIndexPath = indexPath
        performSegue(withIdentifier:"showDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            getUserDefaults()
            let path = "mhlw/" + searchResult[tableView.indexPathForSelectedRow!.row][0] + ".pdf"
            let viewer: PDFViewController = segue.destination as! PDFViewController
            viewer.title = searchResult[tableView.indexPathForSelectedRow!.row][2]
            let button = UIButton(type: UIButtonType.custom) as UIButton
            button.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30))
            button.setImage(UIImage(named: "star.png"), for: UIControlState.normal)
            button.setBackgroundImage(UIImage(named: "starfilled.png"), for: UIControlState.selected)
            button.imageView?.contentMode = .scaleAspectFill
            button.addTarget(self, action: #selector(self.favorite), for: UIControlEvents.touchUpInside)
            if let indexPath = lastIndexPath {
                let i = favList.index { $0 == searchResult[indexPath.row] }
                if (i == nil) {
                    button.isSelected = false
                } else {
                    button.isSelected = true
                }
            }
            viewer.navigationItem.setRightBarButton(UIBarButtonItem(customView:button), animated: true)
            let pdfPath = Bundle.main.path(forResource: path, ofType:nil)!
            let document = PDFKDocument(contentsOfFile: pdfPath, password: nil)
            viewer.loadDocument(document)
        }
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
        userDefaults.synchronize()
    }
    
    func favorite(sender: UIButton) {
        getUserDefaults()
        if let indexPath = lastIndexPath {
            let i = favList.index { $0 == searchResult[indexPath.row] }
            if (i == nil) {
                favList.append(searchResult[lastIndexPath!.row])
                sender.isSelected = true
            } else {
                favList.remove(at:i!)
                sender.isSelected = false
            }
        }
        saveUserDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (tableView.indexPathForSelectedRow != nil) {
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true);
        }
    }
}
