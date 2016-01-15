//
//  main.swift
//  splitandsort
//
//  Created by um on 2016/1/15.
//  Copyright © 2016年 um. All rights reserved.
//

func quickSort(newArray: [(name:String,number:Int)])->Array<(name:String,number:Int)> {
    
    var less = [(name:String,number:Int)]()
    
    var equal = [(name:String,number:Int)]()
    
    var greater = [(name:String,number:Int)]()
    
    if newArray.count > 1{
        var pivot = newArray[0].number
        
        for x in newArray {
            if x.number < pivot{
                less.append((x.name,x.number))
            }
            if x.number == pivot {
                equal.append((x.name,x.number))
            }
            if x.number > pivot {
                greater.append((x.name,x.number))
            }
        }
        return (quickSort(less)+equal+quickSort(greater))
        
    }
    else {
        return newArray
    }
}


func prodDictionary(str : String)-> (fileName:String,number:Int)
{
    var dot : Int = -1
    var outputStr = ""
    for(var i = str.characters.count - 1  ; i >= 0 ; i--){
        let ch:Character = Array(str.characters)[i]
        if ch == "."{
            dot = i
            break
        }
    }
    for(var i = 0 ;i < dot ;i++){
        if( Array(str.characters)[i] >= "0" && Array(str.characters)[i] <= "9"){
            outputStr.append(Array(str.characters)[i])
        }
    }
    
    var num:Int = -1
    
    if let test = Int(outputStr){
        num = Int(outputStr)!
    }
    else{
        print("Convert Error,due to no number !")
    }
    return (str,num)
}


func productSort(strArray:[String]) -> [String]{
    
    var output:[String] = [String]()
    
    //整個Array進來
    var arrList : Array<(name:String,number:Int)> =  Array<(name:String,number:Int)>()
    //分割每個Array保留數字 並且 使用 List 去存
    
    for str in strArray{
        let list  = prodDictionary(str)
        arrList.append((name:list.fileName,number:list.number))
    }
    //以List的數字排序 重建整個陣列
    
    arrList = quickSort(arrList)
    
    for elem in arrList {
        output.append(elem.name)
    }
    
    return output
}
