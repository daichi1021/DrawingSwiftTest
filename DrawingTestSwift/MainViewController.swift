//
//  MainViewController.swift
//  DrawingTestSwift
//
//  Created by Daichi Mizoguchi on 2015/12/27.
//  Copyright © 2015年 Daichi Mizoguchi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var accountDrawingView: ACEDrawingView!
    @IBOutlet weak var accountNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ACEDrawingViewの文字の太さの設定
        accountDrawingView.lineWidth = 3.0
        // ACEDrawingViewの枠の線を設定
        accountDrawingView.layer.borderWidth = 1.0
        
        let saveButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "tapSaveButton:")
        self.navigationItem.rightBarButtonItem = saveButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 保存ボタンタップ
    internal func tapSaveButton(sender: UIButton) {
        insertAccount()
    }
    
    // 取引先Insert
    internal func insertAccount() {
        // 取引先の対象カラムを設定
        let accountFields: Dictionary = ["Name":accountNameField.text!]
        SFRestAPI.sharedInstance().performCreateWithObjectType("Account", fields: accountFields,
            failBlock: {(error : NSError!) -> Void in
                self.queryFailed(error)
            },
            completeBlock: { (responseData : [NSObject:AnyObject]!) -> Void in
                self.insertAccontSucceeded(responseData)
            }
        )
    }
    
    // 取引先Insert完了
    internal func insertAccontSucceeded(responseData : [NSObject:AnyObject]) {
        let accountId: String = responseData["id"] as! String
        print("Insert AccountId:" + accountId)
        self.insertAttachment(accountId)
    }

    // 取引先の添付ファイルInsert
    internal func insertAttachment(accountId: String) {
        // 画像データをBase64に変換
        let signData: NSData = UIImageJPEGRepresentation(accountDrawingView.image, 1.0)!
        let sign64Str:String = signData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        // 添付ファイルの対象カラムを設定
        let attachmenFields: Dictionary = ["ParentId":accountId, "Name":"Sign.jpg", "ContentType":"image/jpeg", "Body":sign64Str]
        SFRestAPI.sharedInstance().performCreateWithObjectType("Attachment", fields: attachmenFields,
            failBlock: {(error : NSError!) -> Void in
                self.queryFailed(error)
            },
            completeBlock: { (responseData : [NSObject:AnyObject]!) -> Void in
                self.insertAttachmentSucceeded(responseData)
            }
        )
    }
    
    // 取引先の添付ファイルInsert完了
    internal func insertAttachmentSucceeded(responseData : [NSObject:AnyObject]) {
        let AttachmentId: String = responseData["id"] as! String
        print("Insert AttachmentId:" + AttachmentId)
    }
    
    // クエリが失敗
    internal func queryFailed(error : NSError) {
        print("Error:" + error.description)
    }
    
    
}

