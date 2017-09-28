//
//  ViewController.swift
//  SearchTicket
//
//  Created by Bolo on 2017/9/27.
//  Copyright © 2017年 Bolo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import UserNotifications
class ViewController: UIViewController {

    var zy_cd_URL = "https://kyfw.12306.cn/otn/leftTicket/queryX?leftTicketDTO.train_date=2017-10-08&leftTicketDTO.from_station=ZYW&leftTicketDTO.to_station=CDW&purpose_codes=ADULT"
    var cd_zy_URL = "https://kyfw.12306.cn/otn/leftTicket/queryX?leftTicketDTO.train_date=2017-10-07&leftTicketDTO.from_station=CDW&leftTicketDTO.to_station=ZYW&purpose_codes=ADULT"
    
    @IBOutlet weak var zy_cd_btn: UIButton!
    
    @IBOutlet weak var cd_zy_btn: UIButton!
    
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var chooseDateView: UIView!
    
    @IBOutlet weak var picker: UIDatePicker!
    var stringDate:String!{
        didSet{
            self.labelDate.text = "乘车日期：\(stringDate!)"
            self.zy_cd_URL = "https://kyfw.12306.cn/otn/leftTicket/queryX?leftTicketDTO.train_date=\(self.stringDate!)&leftTicketDTO.from_station=ZYW&leftTicketDTO.to_station=CDW&purpose_codes=ADULT"
            self.cd_zy_URL = "https://kyfw.12306.cn/otn/leftTicket/queryX?leftTicketDTO.train_date=\(self.stringDate!)&leftTicketDTO.from_station=CDW&leftTicketDTO.to_station=ZYW&purpose_codes=ADULT"
        }
    }
    
    @IBOutlet weak var search: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    var model:DataModel?{
        didSet{
            self.model?.haveTicket.forEach{ self.sendNotification($0) }
            self.tableView.reloadData()
        }
    }
    
    var timer:Timer?
    var searchNum:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        stringDate = formatter.string(from: today)
        self.labelDate.text = "今天：\(stringDate!)"
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.title = "总查询次数：0次"
    }

}



extension ViewController{
    
    @IBAction func zy_cd_click(_ sender: UIButton) {
        clearbtnState()
        sender.isSelected = true
    }
    
    @IBAction func cd_zy_click(_ sender: UIButton) {
        clearbtnState()
        sender.isSelected = true
    }
    
    @IBAction func chooseDateClick(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.chooseDateView.alpha = 1.0
        }
    }
    
    @IBAction func searchClick(_ sender: UIButton) {
        if sender.titleLabel?.text == "开始查询"{
            sender.setTitle("定时查询中...", for: .normal)
            startTimer()
        }else{
            sender.setTitle("开始查询", for: .normal)
            stopTimer()
        }
    }
    
    
    @IBAction func cancelClick(_ sender: UIButton) {
        disappearView()
    }
    
    @IBAction func chooseSureClick(_ sender: Any) {
        disappearView()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        stringDate = formatter.string(from: self.picker.date)
    }
    
    func disappearView(){
        UIView.animate(withDuration: 0.5) {
            self.chooseDateView.alpha = 0
        }
    }
    
    func clearbtnState(){
        self.cd_zy_btn.isSelected = false
        self.zy_cd_btn.isSelected = false
    }
    
    
    @objc func requestTicket(){
        self.searchNum += 1
        self.title = "总查询次数：\(self.searchNum)次"
        
        let url = self.zy_cd_btn.isSelected ? self.zy_cd_URL : self.cd_zy_URL
        
        let manager = SessionManager.default
        manager.delegate.sessionDidReceiveChallenge = {
            session,challenge in
            return (URLSession.AuthChallengeDisposition.useCredential,URLCredential(trust:challenge.protectionSpace.serverTrust!))
        }
        
        //查询
        Alamofire.request(url,method:.get).responseJSON { (response) in
            if response.result.isSuccess{
                if let value = response.result.value{
                    let json = JSON(value)
                    let data = json["data"].dictionary
                    let reslut = data!["result"]!.array
                    self.model = DataModel(data: reslut!)
                }
            }
        }
    }
    
    
    //发送通知
    func sendNotification(_ sender: String) {
        // 1
        let content = UNMutableNotificationContent()
        content.title = "有车票可以预定了啊！"
        content.subtitle = "赶快登陆12306买票"
        content.body = sender
        // 2
        let imageName = "吹牛图标.png"

        let imageURL = Bundle.main.path(forResource: imageName, ofType:nil)!
        
        
        let attachment = try! UNNotificationAttachment(identifier: "my_notification", url: URL(fileURLWithPath:imageURL), options: .none)
        content.attachments = [attachment]
        
        // 3
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: "my_notification", content: content, trigger: trigger)
        
        // 4
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}


extension ViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model?.haveTicket.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = self.model?.haveTicket[indexPath.row]
        cell?.textLabel?.textColor = UIColor.green
        return cell!
    }
}

//定时器
extension ViewController{
    
    func startTimer(){
        self.timer = Timer(timeInterval: 300, target: self, selector: #selector(self.requestTicket), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: .defaultRunLoopMode)
    }
    
    func stopTimer(){
        self.timer?.invalidate()
        self.timer = nil
    }
}


