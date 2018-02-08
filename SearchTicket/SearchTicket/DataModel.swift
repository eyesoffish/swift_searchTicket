//
//  DataModel.swift
//  SearchTicket
//
//  Created by Bolo on 2017/9/27.
//  Copyright © 2017年 Bolo. All rights reserved.
//

import Foundation
import SwiftyJSON
struct DataModel {
    var data:Array<JSON>?
    var stringDate:String?
    var haveTicket:[NSMutableAttributedString] = []
    init(data:Array<JSON>) {
        for i in data{
            var array = i.string!.split(separator: "|")
            if array[0].count > 20 { array.remove(at: 0)}
            let carNum = array[2]
            if carNum.contains("G"){
                let temp = "车次：\(carNum)，出发时间：\(array[7]),到达时间:\(array[8]),乘车日期：\(array[12]),二等坐:"
                let temp2 = NSMutableAttributedString(string: temp)
                temp2.addAttributes([NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14)], range: NSMakeRange(3, 5))
                let temp3 = NSMutableAttributedString(string: "\(array[20])", attributes: [NSAttributedStringKey.foregroundColor:UIColor.green])
                temp2.append(temp3)
                if array[20] != "无"{
                    self.haveTicket.append(temp2)
                }
            }
        }
    }
}
