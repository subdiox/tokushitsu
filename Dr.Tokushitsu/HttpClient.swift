//
//  HttpClient.swift
//  Dr.Tokushitsu
//
//  Created by subdiox on 2017/04/10.
//  Copyright © 2017年 com.gmail.ooka.dev. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit
import CommonCrypto

enum HMACAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func toCCHmacAlgorithm() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:
            result = kCCHmacAlgMD5
        case .SHA1:
            result = kCCHmacAlgSHA1
        case .SHA224:
            result = kCCHmacAlgSHA224
        case .SHA256:
            result = kCCHmacAlgSHA256
        case .SHA384:
            result = kCCHmacAlgSHA384
        case .SHA512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

// sha256を生成するextension
extension String {
    var sha256: String {
        if let cstr = self.cString(using: String.Encoding.utf8) {
            var chars = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            CC_SHA256(
                cstr,
                CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8)),
                &chars
            )
            return chars.map { String(format: "%02X", $0) }.reduce("", +)
        }
        return ""
    }
    
    func hmac(algorithm: HMACAlgorithm, key: String) -> String {
        let cKey = key.cString(using: String.Encoding.utf8)
        let cData = self.cString(using: String.Encoding.utf8)
        var result = [CUnsignedChar](repeating: 0, count: Int(algorithm.digestLength()))
        CCHmac(algorithm.toCCHmacAlgorithm(), cKey!, Int(strlen(cKey!)), cData!, Int(strlen(cData!)), &result)
        let hmacData = Data(bytes: result, count: (Int(algorithm.digestLength())))
        let hmacString = String(data:hmacData, encoding:.utf8)
        return hmacString!
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class HttpClient {
    
    class func getApiUrl() -> String {
        return "https://rheumatology-allergy.net"
    }
    
    class func register(email: String, username: String, password: String) -> Bool {
        let url = getApiUrl() + "/signup"
        let parameters = [
            "email": email,
            "username": username,
            "password": password
        ]
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        var keepAlive = true
        var success = false
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                let statusCode: Int = (response.response?.statusCode)!
                NSLog("statusCode: %d", statusCode)
                switch statusCode {
                case 200:
                    success = true
                default:
                    break
                }
                keepAlive = false
        }
        //ロックが解除されるまで待つ
        let runLoop = RunLoop.current
        while keepAlive &&
            runLoop.run(mode: RunLoopMode.defaultRunLoopMode, before: NSDate(timeIntervalSinceNow: 0.1) as Date) {
                // 0.1秒毎の処理なので、処理が止まらない
        }
        return success
    }
    
    class func login(username: String, password: String) -> Bool {
        let url = getApiUrl() + "/login"
        let parameters = [
            "username": username,
            "password": password
        ]
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        var keepAlive = true
        var success = false
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                let statusCode: Int = (response.response?.statusCode)!
                NSLog("statusCode: %d", statusCode)
                switch statusCode {
                case 200:
                    success = true
                default:
                    break
                }
                keepAlive = false
        }
        //ロックが解除されるまで待つ
        let runLoop = RunLoop.current
        while keepAlive &&
            runLoop.run(mode: RunLoopMode.defaultRunLoopMode, before: NSDate(timeIntervalSinceNow: 0.1) as Date) {
                // 0.1秒毎の処理なので、処理が止まらない
        }
        return success
    }
}
