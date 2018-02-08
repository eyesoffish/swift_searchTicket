//
//  ObjExtension.swift
//  SearchTicket
//
//  Created by 邹琳 on 2018/2/1.
//  Copyright © 2018年 Bolo. All rights reserved.
//

import UIKit

//MARK:-----------提示信息-------------//
/** 仅仅是一个提示 */
func alertMessage(control:UIViewController,title:String = "提示",message:String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
    alert.addAction(action)
    control.present(alert, animated: true, completion: nil)
}

