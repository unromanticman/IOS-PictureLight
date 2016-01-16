//
//  NewViewController.swift
//  PictureLight
//
//  Created by um on 2016/1/3.
//  Copyright © 2016年 um. All rights reserved.
//

import UIKit

class NewViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    
    var titleString :String!
    
    
    var tableData:[String] = []
    var tableImages:[String] = []
    
    var selectedFileName :String = ""
    var selectedFileTag :String = ""
    var selectedFileIndex :Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        /*取得Tag所有圖片*/
        let manager = NSFileManager.defaultManager()
        let urlForDocument = manager.URLsForDirectory( NSSearchPathDirectory.DocumentDirectory, inDomains:NSSearchPathDomainMask.UserDomainMask)
        let url = urlForDocument[0] as NSURL
        
        let contentsOfPath = try? manager.contentsOfDirectoryAtPath(url.path!+"/PictureLightFile/Tag/"+titleString)
        
        print("contentsOfPath: \(url.path!)/PictureLightFile/Tag/\(contentsOfPath)")
        
        var tagItem : [String] = contentsOfPath!
        
        tagItem = productSort(tagItem)
        
        for(var i=0;i<tagItem.count;i++)
        {
            if(tagItem[i] != ".DS_Store")
            {
                tableData.append(tagItem[i])
                tableImages.append(tagItem[i])
            }
        }
        
        
        /*取得Tag所有圖片*/
        
        //設定標題
        self.titleLabel.text = titleString + "   Count:" + String(tagItem.count)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tableData.count
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell:CollectionViewCell =  collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        
        cell.lblCell.text = self.tableData[indexPath.row]
        print(cell.lblCell.text )
        
        
        //多線程但全在UI做原因是Load異步會造成圖片順序錯誤,目前這樣記憶體MAX約10MB
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            //取得文件
            let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let fileURL = documentsURL.URLByAppendingPathComponent("PictureLightFile/Tag/"+self.titleString + "/" + self.tableData[indexPath.row])
            print(fileURL)
            
            //定義NSURL
            let url = NSURL(string: String(fileURL))
            //取得資料
            let data = NSData(contentsOfURL: url!)
            //初始圖片並加入
            
            cell.imgCell.image = self.scaleToSize(UIImage(data: data!)!
                ,size : CGSize(width: 150,height: 150))
            
            print(self.tableImages[indexPath.row])
            
        })
        
        return cell
        
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("Cell \(indexPath.row)  \(tableData[indexPath.row] )  selected")
        
        selectedFileName = tableData[indexPath.row]
        
        /*傳遞圖片address*/
        
        selectedFileTag  = titleString
        selectedFileIndex = indexPath.row
        self.performSegueWithIdentifier("DetailShow", sender: self)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "DetailShow") {
            
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destinationViewController as! DetailViewController
            // your new view controller should have property that will store passed value
            viewController.titleString = selectedFileName
            viewController.tagString = selectedFileTag
            viewController.allPic = tableData
            viewController.photoindex = selectedFileIndex
            
        }
        
    }
    
    func scaleToSize(img: UIImage, size: CGSize) -> UIImage {
        // 设置成为当前正在使用的context
        UIGraphicsBeginImageContext(size)
        // 绘制改变大小的图片
        img.drawInRect(CGRectMake(0, 0, size.width, size.height))
        // 从当前context中创建一个改变大小后的图片
        var scaledImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        // 使当前的context出堆栈
        UIGraphicsEndImageContext()
        // 返回新的改变大小后的图片
        return scaledImage
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
