import UIKit

class PictureLightData  {
    
    var tag:String = ""
    var fileName:String = ""
    var fileContent:String = ""
    init(){
    }
    init(t:String,fn:String,fc:String){
        
        self.setTag(t).setFileName(fn).setFileContent(fc)
        
    }
    func setTag(tag:String) -> Self
    {
        self.tag = tag
        return self
    }
    
    func setFileName(fn:String) -> Self
    {
        self.fileName = fn
        return self
    }
    
    func setFileContent(fc:String) -> Self
    {
        self.fileContent = fc
        return self
    }
    
    func getTag() -> String{ return  self.tag }
    
    func getFileName() -> String{ return self.fileName }
    
    func getFileContent() -> String{  return self.fileContent }
    
}