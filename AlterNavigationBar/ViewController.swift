//
//  ViewController.swift
//  AlterNavigationBar
//
//  Created by 游侠 on 15/5/7.
//  Copyright (c) 2015年 rc.com. All rights reserved.
//

import UIKit

let kScreenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
let kScreenHeight = CGRectGetHeight(UIScreen.mainScreen().bounds)

enum ScrollDrection : Int {
    case None
    case Up
    case Down
}
var lastPosition: CGFloat?

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var tableview: UITableView!
    var centerView: UILabel!
    var searchBar: UILabel!
    var topBackView: UIView!
    var searchField: UILabel!
    var drection: ScrollDrection?
    var barColor: UIColor!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.barColor = UIColor(red: 28 / 255, green: 151 / 255, blue: 238 / 255, alpha: 1)

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navi_back_image.png"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage.alloc()
        self.setNavigationItem()
        
        tableview = UITableView(frame: CGRectMake(0, -64, kScreenWidth, kScreenHeight), style: .Plain)
        tableview.delegate = self
        tableview.dataSource = self
        UIScrollView
        tableview.backgroundColor = UIColor.lightGrayColor()
        tableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        var headerView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 200))
        headerView.tag = 10086
        headerView.backgroundColor = UIColor.whiteColor()
        
        var headerImageView = UIImageView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 160))
        headerImageView.image = UIImage(named: "table_header")
        headerView.addSubview(headerImageView)
        
        searchBar = UILabel(frame: CGRectMake(5, 165, kScreenWidth - 10, 30))
        searchBar.text = "    演员,影片名"
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        headerView.addSubview(searchBar)
        
        self.tableview.tableHeaderView = headerView
        
        self.view .addSubview(tableview)
        lastPosition = tableview.contentOffset.y
        // Do any additional setup after loading the view, typically from a nib.
    }
    //MARK: navigation Item 
    func setNavigationItem() {
 
        
        var rightItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "showMenu")
        rightItem.tintColor = UIColor.orangeColor()
        self.navigationItem.rightBarButtonItem = rightItem
        
        var leftItem = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: "showMenu")
        leftItem.tintColor = UIColor.orangeColor()
        self.navigationItem.leftBarButtonItem = leftItem
        
        topBackView = UIView(frame: CGRectMake(0, -20, kScreenWidth, 64))
        topBackView.backgroundColor = UIColor(red: 0.7, green: 0.8, blue: 1, alpha: 0)
        topBackView.clipsToBounds = true
        self.navigationController?.navigationBar .insertSubview(topBackView, atIndex: 0)
        
        searchField = UILabel(frame: CGRectMake(55, 65, kScreenWidth - 110, 30))
        searchField.text = "    演员,影片名"
        searchField.backgroundColor = UIColor.clearColor()
        searchField.layer.borderColor = UIColor.lightGrayColor().CGColor
        searchField.layer.borderWidth = 1
        topBackView.addSubview(searchField)
        
        centerView = UILabel(frame: CGRectMake(kScreenWidth/2 - 60, 0, 120, 38))
        centerView.textAlignment = .Center
        centerView.textColor = UIColor.whiteColor()
        centerView.text = "Logo"
        centerView.font = UIFont.boldSystemFontOfSize(20)
        self.navigationController?.navigationBar.insertSubview(centerView,  aboveSubview: topBackView)
        
    }
    
    func showMenu() {
        println("showMenu")
    }
    //MARK: tableView Datasource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let defaultCellId = "DefaultCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(defaultCellId, forIndexPath: indexPath) as? UITableViewCell
        if ((cell) == nil) {
            cell = UITableViewCell(style: .Default, reuseIdentifier: defaultCellId)
        }
        cell?.textLabel!.text = "text"
        return cell!
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //MARK: tableView Delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    //MARK: scrollView Delegate
    /*
        1.缩放阶段
        2.转移阶段
        3.变色阶段
        
        4.logo 移动阶段
    */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //判断滑动方向
        var currentPosition: CGFloat = tableview.contentOffset.y
        if currentPosition - lastPosition!  > 0.3 {
            lastPosition = currentPosition
            self.drection = ScrollDrection.Up
        }else if lastPosition! - currentPosition > 0.3 {
            lastPosition = currentPosition
            self.drection = ScrollDrection.Down
        }
        println("偏移量 -> \(currentPosition)")

        //logo 移动
        if currentPosition >= -64 && currentPosition < 36 {
            var percentage = (currentPosition + 64) / CGFloat(100)
            centerView.frame = CGRectMake(kScreenWidth/2 - 60, 0 - 64 * percentage, 120, 38)
        }
      
        if currentPosition >= -64 && currentPosition < 0 {
            topBackView.backgroundColor = UIColor.clearColor()
            searchBar.frame = CGRectMake(5, 165, kScreenWidth - 10,  30)

            searchField.hidden = true
        }else if currentPosition >= 0 && currentPosition < 37 {
//            输入框缩放
            var percentage = currentPosition / 37
            searchBar.frame = CGRectMake(5 + 50 * percentage , 165, kScreenWidth - 10 - 100 * percentage, 30)
            searchField.hidden = true
            
        }else if currentPosition >= 37 && currentPosition < 77 {

            /* 
            1.输入框交叉
            2.边框颜色
            3.文字颜色
            */
            searchField.hidden = false
            searchBar.frame = CGRectMake(55, 165, kScreenWidth-110, 30)
            searchField.frame = CGRectMake(55, 64 - (currentPosition - 37), kScreenWidth - 110, 30)
            
            var percent = (currentPosition - 37) / 40
            searchField.layer.borderColor = UIColor(white: 1, alpha: percent*0.85).CGColor
            searchField.textColor = UIColor(white: 1, alpha: percent)
            topBackView.backgroundColor = UIColor(red: 28 / 255, green: 141 / 255, blue: 218 / 255, alpha: percent*0.85)
            
        }else if currentPosition >= 77 {
            searchField.hidden = false
            searchField.frame = CGRectMake(55, 25, kScreenWidth - 110, 30)
            centerView.frame = CGRectMake(kScreenWidth/2 - 60, 0 - 64, 120, 38)
            topBackView.backgroundColor = barColor
            searchField.textColor = UIColor.whiteColor()
            searchField.layer.borderColor = UIColor.whiteColor().CGColor
            
        }
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
         println(__FUNCTION__)
        if scrollView.contentOffset.y >= 36 && scrollView.contentOffset.y < 76 {
            if self.drection == ScrollDrection.Down {
                self.tableview.setContentOffset(CGPointMake(0, -64), animated: true)
            }else if self.drection == ScrollDrection.Up {
                self.tableview.setContentOffset(CGPointMake(0, 76), animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

