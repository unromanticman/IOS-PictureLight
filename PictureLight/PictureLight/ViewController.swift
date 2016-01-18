//
//  ViewController.swift
//  PictureLight
//
//  Created by um on 2016/1/3.
//  Copyright © 2016年 um. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
  
    @IBOutlet weak var aboutBtn: UIBarButtonItem!
    
    var objects: NSMutableArray! = NSMutableArray()
    
    @IBAction func AboutBtn(sender: AnyObject) {
        let url = NSURL(string: "https://github.com/unromanticman/Picture-Light-ReadMe")!
        UIApplication.sharedApplication().openURL(url)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
            self.title = "Picture Light"
            let manager = NSFileManager.defaultManager()
            let urlForDocument = manager.URLsForDirectory( NSSearchPathDirectory.DocumentDirectory, inDomains:NSSearchPathDomainMask.UserDomainMask)
            let url = urlForDocument[0] as NSURL
            
            if let test = try?(manager.contentsOfDirectoryAtPath(url.path!+"/PictureLightFile/Tag/")) {
                print("Have file")
                let contentsOfPath = try? manager.contentsOfDirectoryAtPath(url.path!+"/PictureLightFile/Tag/")
                
                print("contentsOfPath: \(url.path!)/PictureLightFile/Tag/\(contentsOfPath)")
                var tagItem : [String] = contentsOfPath!
                
                for(var i=0;i<tagItem.count;i++)
                {
                    if(tagItem[i] != ".DS_Store")
                    {
                        self.objects.addObject(tagItem[i])
                    }
                }
                self.tableView.reloadData()
            }
            else{
                print("Does't have file")
            }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects.count
    }

    //根據cellForRowAtIndexPath來取得目前TableView需要哪個cell的資料
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 取得tableView目前使用的cell
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        
        // 將指定資料顯示於tableview提供的text
        cell.titleLabel.text = self.objects.objectAtIndex(indexPath.row) as? String
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "showView") {
            
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destinationViewController as! NewViewController
            // your new view controller should have property that will store passed value
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            viewController.titleString = self.objects.objectAtIndex(indexPath.row) as? String
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showView", sender: self)
    }
    
  
    
}

