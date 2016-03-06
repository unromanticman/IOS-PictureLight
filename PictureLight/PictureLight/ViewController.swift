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
    
        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: "What to you want to do ?", message: "", preferredStyle:.ActionSheet)
            let firstAction = UIAlertAction(title: "Watch Read Me", style: .Default) { (alert: UIAlertAction!) -> Void in
                let url = NSURL(string: "https://github.com/unromanticman/Picture-Light-ReadMe")!
                UIApplication.sharedApplication().openURL(url)
            }
            
            let secondAction = UIAlertAction(title: "Clean All Picture", style: .Default) { (alert: UIAlertAction!) -> Void in
            
                if #available(iOS 8.0, *) {
                    let alert = UIAlertController(title: "Do you want to clean all pitcure?", message: "", preferredStyle:.ActionSheet)
                    
                    let firstAction = UIAlertAction(title: "YES", style: .Default) { (alert: UIAlertAction!) -> Void in
                        self.cleanallPicture()
                    }
                    
                    let secondAction = UIAlertAction(title: "NO", style: .Default) { (alert: UIAlertAction!) -> Void in
                   
                    }
                    alert.addAction(firstAction)
                    alert.addAction(secondAction)
                    alert.popoverPresentationController!.sourceView = self.view
                    alert.popoverPresentationController!.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
                  
                    self.presentViewController(alert, animated: true, completion:nil)
                    
                } else {
              
                }
                
            }
            let thirdAction = UIAlertAction(title: "Cancel", style: .Default) { (alert: UIAlertAction!) -> Void in
                
            }
            alert.addAction(firstAction)
            alert.addAction(secondAction)
            alert.addAction(thirdAction)
            alert.popoverPresentationController!.sourceView = self.view
            alert.popoverPresentationController!.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)

            presentViewController(alert, animated: true, completion:nil)
        } else {
           
        }
              

    }
    
    private func cleanallPicture(){
        //Clean iTunes all files
        let fileManager = NSFileManager.defaultManager()
        let myDirectory = NSHomeDirectory() + "/Documents/"
        let fileArray:[AnyObject]? = fileManager.subpathsAtPath(myDirectory)
        for fn in fileArray!{
            do
            {
                try! fileManager.removeItemAtPath(myDirectory + "/\(fn)")

            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }

        
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

