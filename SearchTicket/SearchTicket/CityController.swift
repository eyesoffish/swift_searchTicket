//
//  CityController.swift
//  SearchTicket
//
//  Created by 邹琳 on 2018/2/1.
//  Copyright © 2018年 Bolo. All rights reserved.
//

import UIKit

class CityController: UIViewController {

    let hotData = ["北京":"BJP","上海":"SHH","天津":"TJP","重庆":"CQW","长沙":"CSQ","长春":"CCT","成都":"CDW","福州":"FZS","广州":"GZQ","贵阳":"GIW","呼和浩特":"HHC","哈尔滨":"HBB","合肥":"HFH","杭州":"HZH","海口":"VUQ","济南":"JNK","昆明":"KMM","拉萨":"LSO","兰州":"LZJ","南宁":"NNZ","南京":"NJH","南昌":"NCG","沈阳":"SYT","石家庄":"SJP","太原":"TYV","乌鲁木齐南":"WMR","武汉":"WHN","西宁":"XNO","西安":"XAY","银川":"YIJ","郑州":"ZZF","深圳":"SZQ","厦门":"XMS","资阳":"ZYW"]
    typealias CityCallback = ((String,String))->()
    var callback:CityCallback?
//    let all_city_data = ["阿尔山":"ART","安康":"AKY","阿克苏":"ASR","阿里河":"AHX","阿拉山口":"AKR","安平":"APT","安庆":"AQH","安顺":"ASW","鞍山":"AST","安阳":"AYF","昂昂溪":"AAX","阿城":"ACB","北京北":"VAP","北京东":"BOP","北京":"BJP","北京南":"VNP","北京西":"BXP","北安":"BAB","蚌埠":"BBH","白城":"BCT","北海":"BHZ","白河":"BEL","白涧":"BAP","宝鸡":"BJY","重庆北":"CUW","重庆":"CQW","重庆南":"CRW","重庆西":"CXW","长春":"CCT","长春南":"CET","长春西":"CRT","成都东":"ICW","成都南":"CNW","成都":"CDW","长沙":"CSQ","长沙南":"CWQ","大安北":"RNT","大成":"DCT","丹东":"DUT","东方红":"DFB","东莞东":"DMQ","大虎山":"DHD","敦煌":"DHJ","敦化":"DHL","德惠":"DHT","东京城":"DJB","大涧":"DFP","都江堰":"DDW","额济纳":"EJC","二连":"RLC","恩施":"ESN","峨边":"EBW","二道沟门":"RDP","二道湾":"RDX","鄂尔多斯":"EEC","二龙":"RLD","二龙山屯":"ELA","峨眉":"EMW","二密河":"RML","二营":"RYJ","荷塘":"KXQ","黄土店":"HKP","合阳北":"HTY","海阳北":"HEK","槐荫":"IYN","鄠邑":"KXY","花园口":"HYT","霍州东":"HWV","惠州南":"KNQ","洛湾三江":"KRW","莱西北":"LBK","溧阳":"LEH","临邑":"LUK","柳园南":"LNR","鹿寨北":"LSZ","阆中":"LZE","临泽南":"LDJ","平顶山":"PEN","盘锦":"PVD","平凉":"PIJ","平凉南":"POJ","平泉":"PQP","坪石":"PSQ","萍乡":"PXG","凭祥":"PXZ","郫县西":"PCW","攀枝花":"PRW","蓬安":"PAW","平安":"PAL","蕲春":"QRN","青城山":"QSW","青岛":"QDK","清河城":"QYP","曲靖":"QJM","黔江":"QNW","前进镇":"QEB","齐齐哈尔":"QHX","七台河":"QTB","沁县":"QVV","泉州东":"QRS","泉州":"QYS","融安":"RAZ","汝箕沟":"RQJ","瑞金":"RJG","日照":"RZK","瑞安":"RAH","荣昌":"RCW","瑞昌":"RCG","如皋":"RBH","容桂":"RUQ","任丘":"RQP","乳山":"ROK","融水":"RSZ","上海":"SHH","上海南":"SNH","上海虹桥":"AOH","上海西":"SXH","石家庄北":"VVP","石家庄":"SJP","沈阳":"SYT","沈阳北":"SBT","沈阳东":"SDT","沈阳南":"SOT","双城堡":"SCB","绥芬河":"SFB","天津北":"TBP","天津":"TJP","天津南":"TIP","天津西":"TXP","太原北":"TBV","太原东":"TDV","太原":"TYV","塘豹":"TBQ","塔尔气":"TVX","潼关":"TGY","塘沽":"TGP","塔河":"TXX","烟台西":"YTK","尤溪":"YXS","云霄":"YBS","宜兴":"YUH","玉溪":"AXM","阳信":"YVK","应县":"YZV","攸县南":"YXG","洋县西":"YXY","余姚北":"CTH","榆中":"IZJ"]
    
    let tableView:UITableView = {
        let temp = UITableView(frame: UIScreen.main.bounds, style: .plain)
        temp.showsVerticalScrollIndicator = false;
        temp.showsHorizontalScrollIndicator = false;
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "热门城市"
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }

}

extension CityController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hotData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let value = Array(hotData)[indexPath.row]
        cell?.textLabel?.text = value.key
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = Array(hotData)[indexPath.row]
        if callback != nil { callback!((value.key,value.value)) }
        self.navigationController?.popViewController(animated: true)
    }
    
}
