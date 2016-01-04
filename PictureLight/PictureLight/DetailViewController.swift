//
//  DetailViewController.swift
//  PictureLight
//
//  Created by um on 2016/1/4.
//  Copyright © 2016年 um. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var titleString:String = ""
    var tagString:String = ""
    var allPic :[String] = []
    var photoindex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadImageView(photoindex)
        print(photoindex)
        
    }

    
    func LoadImageView(index:Int) ->Void
    {
        do{
            //釋放所謂的ARC
            let subviews = imageView.subviews
            for subview in subviews{
                subview.removeFromSuperview()
            }
            
            let CheckGif:String = String(allPic[index]).uppercaseString
            
            
            //取得偽造圖片URL
            let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let fileURL = documentsURL.URLByAppendingPathComponent("PictureLightFile/Tag/"+tagString + "/" + allPic[index] )
            
            if(CheckGif.containsString(".GIF"))
            {
                imageView.image = nil
                //動圖
                let gif = UIImage.gifWithName(String(fileURL))
                
                let view = UIImageView(image: gif)
                
                view.contentMode = .ScaleAspectFit
                
                view.frame = imageView.frame
                imageView.addSubview(view)
                
            }
            else
            {
                
                //定義NSURL
                let url = NSURL(string: String (fileURL) )
                //取得資料
                let data = NSData(contentsOfURL: url!)
                //初始圖片並加入
                imageView.image = UIImage(data: data!)
                
            }

        }catch
        {
            
        }
        
        
        titleLabel.text = allPic[index]
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //圖片向右
    func changePhotoRight()->Void
    {
        if(photoindex + 1 <= allPic.count - 1)
        {
            LoadImageView(++photoindex)
            
            print(photoindex)
        }
      
    }
    //圖片向左
    func changePhotoLeft()->Void
    {
        
        if(photoindex - 1  >= 0)
        {
            LoadImageView(--photoindex)
            print(photoindex)
        }
    }
    
    @IBAction func nextBtn(sender: AnyObject) {
        changePhotoRight()
    }
    
    @IBAction func prevBtn(sender: AnyObject) {
        changePhotoLeft()
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
