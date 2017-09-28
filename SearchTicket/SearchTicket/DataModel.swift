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
    var haveTicket:[String] = []
    init(data:Array<JSON>) {
        for i in data{
            var array = i.string!.split(separator: "|")
            if array[0].count > 20 { array.remove(at: 0)}
            let carNum = array[2]
            if carNum.contains("G"){
                let temp = "车次：\(carNum)，出发时间：\(array[7]),到达时间:\(array[8]),乘车日期：\(array[12]),二等坐:\(array[20])"
                if array[20] == "有"{
                    self.haveTicket.append(temp)
                }
            }
        }
    }
}
