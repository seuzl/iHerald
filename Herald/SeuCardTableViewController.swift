//
//  SeuCardTableViewController.swift
//  Herald
//
//  Created by lizhuoli on 15/4/5.
//  Copyright (c) 2015年 WangShuo. All rights reserved.
//

import UIKit

class SeuCardTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIGetter{

    @IBOutlet weak var tableView: UITableView!
    
    var detailArray:[NSDictionary]?
    
    var firstLoad = true
    var initResult = false
    var API = HeraldAPI()
    override func viewDidLoad() {
        super.viewDidLoad()
        let background = UIColor(red: 180/255, green: 230/255, blue: 230/255, alpha: 1)
        self.view.backgroundColor = background
        self.tableView.backgroundColor = background
        
        initResult = Tool.initNavigationAPI(self)
        if initResult{
            self.API.delegate = self
            API.sendAPI("cardDetail",APIParameter: "30")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if (initResult && firstLoad){
            firstLoad = false
            Tool.showProgressHUD("正在查询一卡通明细")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        Tool.dismissHUD()
        API.cancelAllRequest()
    }
    
    func getResult(APIName: String, results: JSON) {
        self.tableView.hidden = false
        if let resultsData = results["content"].dictionaryObject{
            Tool.showSuccessHUD("获取一卡通信息成功")
            detailArray = resultsData["detial"] as? [NSDictionary]
            tableView.reloadDataAnimateWithWave(WaveAnimation.RightToLeftWaveAnimation)
        }
        else{
            Tool.showErrorHUD("获取数据失败")
        }
    }
    
    func getError(APIName: String, statusCode: Int) {
        Tool.showErrorHUD("获取数据失败")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailArray?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier:String = "SeuCardTableViewCell"
        let row = indexPath.row
        
        var cell: SeuCardTableViewCell? = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? SeuCardTableViewCell
        if cell == nil {
            let nibArray:NSArray = NSBundle.mainBundle().loadNibNamed("SeuCardTableViewCell", owner: self, options: nil)
            cell = nibArray.objectAtIndex(0) as? SeuCardTableViewCell
        }

        cell?.backgroundColor = UIColor(red: 180/255, green: 230/255, blue: 230/255, alpha: 1)
        
        if let detailInfoArray = detailArray{
            cell?.cardDateLabel.text = detailInfoArray[row].valueForKey("date") as? String ?? ""
            cell?.cardPlaceLabel.text = detailInfoArray[row].valueForKey("system") as? String ?? ""
            cell?.cardPriceLabel.text = detailInfoArray[row].valueForKey("price") as? String ?? ""
            cell?.cardMoneyLabel.text = detailInfoArray[row].valueForKey("left") as? String ?? ""
        }
        return cell!
    }
}
