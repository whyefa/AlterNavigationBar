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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navi_back_image.png"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage.alloc()
        self.setNavigationItem()
        
        tableview = UITableView(frame: CGRectMake(0, -64, kScreenWidth, kScreenHeight), style: .Plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = UIColor.lightGrayColor()
        tableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        var headerView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 180))
        headerView.tag = 10086
        headerView.backgroundColor = UIColor.whiteColor()
        
        var headerImageView = UIImageView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 140))
        headerImageView.image = UIImage(named: "table_header")
        headerView.addSubview(headerImageView)
        
        searchBar = UILabel(frame: CGRectMake(5, 145, kScreenWidth - 10, 30))
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
        rightItem.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightItem
        
        var leftItem = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: "showMenu")
        leftItem.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = leftItem
        
        topBackView = UIView(frame: CGRectMake(0, -20, kScreenWidth, 64))
        topBackView.backgroundColor = UIColor(red: 0.7, green: 0.8, blue: 1, alpha: 0)
        self.navigationController?.navigationBar .insertSubview(topBackView, atIndex: 0)
        
        searchField = UILabel(frame: CGRectMake(55, 25, kScreenWidth - 110, 30))
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
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var currentPosition: CGFloat = tableview.contentOffset.y
        if currentPosition - lastPosition!  > 0.3 {
            lastPosition = currentPosition
            self.drection = ScrollDrection.Up
        }else if lastPosition! - currentPosition > 0.3 {
            lastPosition = currentPosition
            self.drection = ScrollDrection.Down
        }
        var offset = CGFloat(tableview.contentOffset.y)

        if offset < 55  && offset > 10{
            var alpha = (offset - 10) / CGFloat(45)
            topBackView.backgroundColor = UIColor(red: 0.7, green: 0.8, blue: 1, alpha: alpha)
            centerView.frame = CGRectMake(kScreenWidth/2 - 60, 0 - 64 * alpha, 120, 38)
        }else if offset > 55 {
            topBackView.backgroundColor = UIColor(red: 0.7, green: 0.8, blue: 1, alpha: 1)
        }else if offset < 10 {
            topBackView.backgroundColor = UIColor(white: 1, alpha: 0)
        }
        
        if offset > 42 && offset < 54 {
            
            searchField!.hidden = false
            searchField.layer.borderColor = UIColor(white: 1, alpha: CGFloat((offset - 42) / 12)).CGColor
            var rect = searchBar.frame
            rect.origin.y = 25 - (offset - 42) + 13.5
            searchField.frame = rect
            println(rect.origin.y)
        }else if offset > 54 {
            searchField.layer.borderColor = UIColor.whiteColor().CGColor
        }else {
            searchBar.layer.borderColor = UIColor.lightGrayColor().CGColor
        }
        if offset > -48 && offset < 8 {
            var percentage = (offset + 48) / 56
            searchBar.frame = CGRectMake(5 + 50 * percentage , 145, kScreenWidth - 10 - 100 * percentage, 30)
        }else if offset < 42 {
            searchField!.hidden = true
        }

    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > -64 && scrollView.contentOffset.y < 56 {
            if self.drection == ScrollDrection.Down {
                self.tableview.setContentOffset(CGPointMake(0, -64), animated: true)
            }else if self.drection == ScrollDrection.Up {
                self.tableview.setContentOffset(CGPointMake(0, 56), animated: true)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

