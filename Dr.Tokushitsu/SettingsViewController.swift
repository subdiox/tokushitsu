//
//  SettingsViewController.swift
//  Dr.Tokushitsu
//
//  Created by subdiox on 2017/03/05.
//  Copyright © 2017年 com.gmail.ooka.dev. All rights reserved.
//

import UIKit
import M13PDFKit

class SettingsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "はじめに"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "利用規約"
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "情報"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.navigationController?.topViewController != self {
            return
        }
        self.performSegue(withIdentifier:"showDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            var path = ""
            let indexPath = tableView.indexPathForSelectedRow!
            let viewer: PDFKBasicPDFViewer = segue.destination as! PDFKBasicPDFViewer
            if indexPath.row == 0 {
                path = "intro.pdf"
                viewer.title = "はじめに"
            } else if indexPath.row == 1 {
                path = "tos.pdf"
                viewer.title = "利用規約"
            }
            let pdfPath = Bundle.main.path(forResource: path, ofType:nil)!
            let document = PDFKDocument(contentsOfFile: pdfPath, password: nil)
            viewer.loadDocument(document)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (tableView.indexPathForSelectedRow != nil) {
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true);
        }
    }
}
