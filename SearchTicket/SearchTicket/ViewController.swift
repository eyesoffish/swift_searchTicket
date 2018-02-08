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

    var request_url:String!
    var beginCity:String = "CDW"
    var endCity:String = "ZYW"
    
    @IBOutlet weak var zy_cd_btn: UIButton!
    
    @IBOutlet weak var cd_zy_btn: UIButton!
    
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var chooseDateView: UIView!
    
    @IBOutlet weak var picker: UIDatePicker!
    var stringDate:String!{
        didSet{
            self.labelDate.text = "乘车日期：\(stringDate!)"
            
        }
    }
    
    @IBOutlet weak var search: UIButton!
    /** 马上查询 */
    @IBOutlet weak var btnSearchNow: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var model:DataModel?{
        didSet{
            self.model?.haveTicket.forEach{ self.sendNotification($0.string) }
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
        self.tableView.register(UINib(nibName:"TableViewCell",bundle:nil), forCellReuseIdentifier: "cell")
        self.title = "总查询次数：0次"
        self.picker.date = today
    }

    @IBAction func search_rightNow(_ sender: UIButton) {
        if sender.titleLabel?.text == "立刻查询"{
            requestTicket()
            sender.setTitle("查询中...", for: .normal)
        }else{
            alertMessage(control: self, message: "请稍后...")
        }
    }
    @IBAction func clear_data(_ sender: Any) {
        self.model?.haveTicket.removeAll()
        self.tableView.reloadData()
    }
}



extension ViewController{
    
    /** 出发地 */
    @IBAction func zy_cd_click(_ sender: UIButton) {
        clearbtnState()
        let vc = CityController()
        vc.callback = { value in
            self.beginCity = value.1
            sender.setTitle(value.0, for: .normal)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /** 目的地 */
    @IBAction func cd_zy_click(_ sender: UIButton) {
        clearbtnState()
        let vc = CityController()
        vc.callback = {value in
            self.endCity = value.1
            sender.setTitle(value.0, for: .normal)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func chooseDateClick(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.chooseDateView.alpha = 1.0
        }
    }
    
    @IBAction func searchClick(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "定时查询"{
            alertMessage(control: self, message: "开始定时查询，每隔5分钟查询一次")
            sender.setTitle("定时查询中...", for: .normal)
            startTimer()
        }else{
            sender.setTitle("定时查询", for: .normal)
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
        
        self.request_url = "https://kyfw.12306.cn/otn/leftTicket/queryZ?leftTicketDTO.train_date=\(self.stringDate!)&leftTicketDTO.from_station=\(beginCity)&leftTicketDTO.to_station=\(endCity)&purpose_codes=ADULT"
        
        let manager = SessionManager.default
        //如果限制了https:的话就调用这个
        manager.delegate.sessionDidReceiveChallenge = {
            session,challenge in
            return (URLSession.AuthChallengeDisposition.useCredential,URLCredential(trust:challenge.protectionSpace.serverTrust!))
        }
        print(request_url)
        //查询
        Alamofire.request(self.request_url,method:.get).responseJSON { (response) in
            self.btnSearchNow.setTitle("立刻查询", for: .normal)
            if response.result.isSuccess{
                if let value = response.result.value{
                    print(value)
                    let json = JSON(value)
                    guard let data = json["data"].dictionary else {
                        alertMessage(control: self, message: json["data"].string ?? "")
                        return
                    }
                    guard let result = data["result"]?.array else {
                        alertMessage(control: self, message: json["data"].string ?? "")
                        return
                    }
                    self.model = DataModel(data: result)
                }
            }else{
                alertMessage(control: self, message: "请求出错误")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell
//        cell?.labelContent.text = self.model?.haveTicket[indexPath.row]
        cell?.labelContent.attributedText = self.model?.haveTicket[indexPath.row]
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


