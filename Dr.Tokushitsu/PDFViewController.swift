//
//  PDFViewController.swift
//  Dr.Tokushitsu
//
//  Created by subdiox on 2017/03/11.
//  Copyright © 2017年 com.gmail.ooka.dev. All rights reserved.
//

import UIKit
import M13PDFKit

class PDFViewController : PDFKBasicPDFViewer {
    override func viewDidLoad() {
        super.viewDidLoad()
        let textView = UITextView(frame: CGRect(origin: CGPoint(x: 72, y: 72), size: CGSize(width: 290, height: 20)))
        textView.isEditable = false
        textView.isSelectable = false
        textView.backgroundColor = UIColor.clear
        textView.text = "厚生労働省の指定難病、概要、診断基準等より抜粋"
        self.view.addSubview(textView)
        self.view.bringSubview(toFront: textView)
    }
}
