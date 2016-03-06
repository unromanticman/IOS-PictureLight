//
//  DetailViewController.swift
//  PictureLight
//
//  Created by um on 2016/1/4.
//  Copyright © 2016年 um. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,NSXMLParserDelegate,UIScrollViewDelegate{

    @IBOutlet weak var zoomScrollView: UIScrollView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var picTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var autoBtn: UIButton!
    @IBOutlet weak var autoTime: UIBarButtonItem!
    var timerflag = false;
    var autoTimer:NSTimer!
    var titleString:String = ""
    var tagString:String = ""
    var allPic :[String] = []
    var photoindex : Int = 0
    /* XML Paser */
    var parser : NSXMLParser?
    var element : String?
    var pcLightData : [PictureLightData] = []
    /* XML Paser */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化 Paser
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent("PictureLightFile/Config.xml")
        print(fileURL)
        
        
         if let parser = NSXMLParser(contentsOfURL: fileURL){
            parser.delegate = self
            parser.parse()
        }

        //載入圖片
        LoadImageView(photoindex)
        print(photoindex)
        
    
        
        //初始化ScrollSize
        
        self.zoomScrollView.minimumZoomScale = 1.0
        self.zoomScrollView.maximumZoomScale = 6.0
        
        //Touch
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
      
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        zoomScrollView.addGestureRecognizer(leftSwipe)
        zoomScrollView.addGestureRecognizer(rightSwipe)
        
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer)
    {
        if(zoomScrollView.zoomScale == 1.0)
        {
            if(sender.direction == .Left)
            {
                changePhotoRight()
            }
            if(sender.direction == .Right)
            {
                changePhotoLeft()
            }

        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return self.imageView
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
               
                imageView.image = gif
                
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
            
               picTextView.text = getContent(allPic[index])
        }catch
        {
            
        }
        
        
        titleLabel.text = allPic[index]
        
        //還原縮放
        self.zoomScrollView.zoomScale = 1.0
        
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
        else if(timerflag)
        {
            autoTimer.invalidate()
            autoBtn.setTitle("Auto", forState: .Normal)
            timerflag = false
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
 
    
    func getContent(filename:String)->String
    {
        //尋找該檔名的內容
        
        var content : String = ""
        
        
        for element in pcLightData
        {
            if ( element.getFileName() == filename ? true : false ){
               
                content = element.getFileContent()
                break
                
            }
        }
        
        return content
    }

    func parser(parser: NSXMLParser,
        didStartElement elementName: String,
        namespaceURI namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String])
    {
        
        element = elementName
            
    
        if (element == "Information"){
        
    
        let xmlTag = attributeDict ["Tag"] as! NSString
        let xmlFileName = attributeDict ["FileName"] as! NSString
        let xmlFileContent = attributeDict ["FileContent"]! as NSString
        
        if(tagString == xmlTag){
        
            let newItem : PictureLightData  = PictureLightData(t: String(xmlTag) , fn: String(xmlFileName), fc:String(xmlFileContent))
                pcLightData.append(newItem)
                print(xmlFileName)
            }
        }
        
      
    }
    
    func tickDown()
    {
        changePhotoRight()
    }
    
    @IBAction func autoBtn(sender: AnyObject) {
        if(timerflag == false)
        {
            let time :Double = Double((autoTime.customView as! UITextField).text!)!
            autoTimer = NSTimer.scheduledTimerWithTimeInterval(time,
                target:self,selector:Selector("tickDown"),
                userInfo:nil,repeats:true)
            
            timerflag = true
            autoBtn.setTitle("Stop", forState: .Normal)
        }
        else
        {
            autoTimer.invalidate()
            autoBtn.setTitle("Auto", forState: .Normal)
            timerflag = false
        }
        
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
