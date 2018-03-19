//
//  LoginViewController.swift
//  Dr.Tokushitsu
//
//  Created by subdiox on 2017/04/07.
//  Copyright © 2017年 com.gmail.ooka.dev. All rights reserved.
//

import UIKit

class RegisterViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var registerCodeTextField: UITextField!
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "RegisterSegue" {
                if passwordTextField.text != confirmPasswordTextField.text {
                    let alert: UIAlertController = UIAlertController(title: "エラー", message: "パスワードと確認用パスワードが異なっています。", preferredStyle:  UIAlertControllerStyle.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                        (action: UIAlertAction!) -> Void in
                    })
                    alert.addAction(defaultAction)
                    present(alert, animated: true, completion: nil)
                    return false
                }
                let username = userIdTextField.text!
                if registerCodeTextField.text!.characters.count == 5 && !getRegisterCode(username: username).lowercased().hasPrefix(registerCodeTextField.text!) {
                    let alert: UIAlertController = UIAlertController(title: "エラー", message: "登録用コードが間違っています。", preferredStyle:  UIAlertControllerStyle.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                        (action: UIAlertAction!) -> Void in
                    })
                    alert.addAction(defaultAction)
                    present(alert, animated: true, completion: nil)
                    return false
                }
                let email = emailTextField.text!
                let password = passwordTextField.text!
                let userDefaults = UserDefaults.standard
                userDefaults.set(email, forKey: "email")
                userDefaults.set(password, forKey: "password")
                userDefaults.set(username, forKey: "username")
                let resultValue = HttpClient.register(email: email, username: username, password: password)
                if !resultValue {
                    let alert: UIAlertController = UIAlertController(title: "エラー", message: "アカウントの登録に失敗しました。このユーザ名はすでに登録されています。", preferredStyle:  UIAlertControllerStyle.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                        (action: UIAlertAction!) -> Void in
                    })
                    alert.addAction(defaultAction)
                    present(alert, animated: true, completion: nil)
                    return false
                }
            }
        }
        return true
    }
    
    func getRegisterCode(username: String) -> String {
        let registerCode = ("rheumatology-" + username).sha256
        NSLog("registerCode: " + registerCode)
        return registerCode
    }
}

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "LoginSegue" {
                let username = userIdTextField.text!
                let password = passwordTextField.text!
                let userDefaults = UserDefaults.standard
                userDefaults.set(password, forKey:"password")
                userDefaults.set(username, forKey: "username")
                let resultValue = HttpClient.login(username: username, password: password)
                if !resultValue {
                    let alert: UIAlertController = UIAlertController(title: "エラー", message: "ログインに失敗しました。メールアドレスまたはパスワードが間違っています。", preferredStyle:  UIAlertControllerStyle.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                        (action: UIAlertAction!) -> Void in
                    })
                    alert.addAction(defaultAction)
                    present(alert, animated: true, completion: nil)
                    return false
                }
            }
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set("d260b83796537bb9b410b4146ca28a37cfa9b279bafc63d16f2ddbdf8715b9c4", forKey: "TokushitsuKey")
        return true
    }
}

