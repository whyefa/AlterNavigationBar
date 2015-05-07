//
//  ViewController.swift
//  AlterNavigationBar
//
//  Created by 游侠 on 15/5/7.
//  Copyright (c) 2015年 rc.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.clearColor()
        UINavigationBar.appearance().setBackgroundImage(UIImage.alloc(), forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().shadowImage = UIImage.alloc()
        var headerImageView = UIImageView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200))
        headerImageView.image = UIImage(named: "table_header")
        self.tableView.tableHeaderView = headerImageView

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    //MARK: tableView Datasource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let defaultCellId = "Default Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(defaultCellId, forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = "text"
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //MARK: tableView Delegate
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

