//
//  MainVC.swift
//  Moody
//
//  Created by Bhagat Singh on 6/11/17.
//  Copyright © 2017 com.bhagat_singh. All rights reserved.
//

import UIKit
import NKOColorPickerView
import Alamofire

class MainVC: UIViewController{

    //IBOutlets
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pickerView1: NKOColorPickerView!
    @IBOutlet weak var pickerView2: NKOColorPickerView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //Initialisation
    struct color{
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
    }
    
    var color1 = color(r: 0, g: 0, b: 0)
    var color2 = color(r: 0, g: 0, b: 0)
    var tempColor = color(r: 0, g: 0, b: 0)
    var randomColor1 = color(r: 0, g: 0, b: 0)
    var randomColor2 = color(r: 0, g: 0, b: 0)
    
    var hardwareID : Double = 0
    typealias completed = () -> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initial Setup
        setup()
    }
    
    func setup(){
        
        //Picker View Setup
        pickerView1.color = .red
        pickerView2.color = .blue
        
        //Segmented Control Setup
        segmentedControl.selectedSegmentIndex = 0
        
        //Button UI Setup
        doneButton.layer.borderColor = UIColor(red: 227/255, green: 180/255, blue: 74/255, alpha: 1.0).cgColor
        doneButton.layer.borderWidth = 1.5
        doneButton.layer.cornerRadius = 20.0
        
        //Other setup
        pickerView2.isHidden = true
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0{
            color1 = getColor(color: pickerView1.color)
            singleColorCall {
                //do something
            }
        }
        
        if segmentedControl.selectedSegmentIndex == 1{
            color1 = getColor(color: pickerView1.color)
            color2 = getColor(color: pickerView2.color)
            doubleColorCall {
                //do something
            }
        }
        
        if segmentedControl.selectedSegmentIndex == 2{
            randomColorCall {
                //do something
            }
        }
    }
    
    @IBAction func segmentedControlChangedValue(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0{
            pickerView2.isHidden = true
        }
        
        if segmentedControl.selectedSegmentIndex == 1{
            pickerView2.isHidden = false
        }
        
        if segmentedControl.selectedSegmentIndex == 2{
            pickerView2.isHidden = false
            
            randomColor1.r = arc4random_uniform(256)
            randomColor1.g = arc4random_uniform(256)
            randomColor1.b = arc4random_uniform(256)
            
            randomColor2.r = arc4random_uniform(256)
            randomColor2.g = arc4random_uniform(256)
            randomColor2.b = arc4random_uniform(256)
            
            pickerView1.color = UIColor(red: randomColor1.r , green: randomColor1.g, blue: randomColor1.b, alpha: 1.0)
            pickerView1.color = UIColor(red: randomColor2.r , green: randomColor2.g, blue: randomColor2.b, alpha: 1.0)
        }
    }
    
    func singleColorCall(completed: @escaping completed){
        Alamofire.request("https://akshaybaweja.com/mood.php?request=set&HID=\(hardwareID)&r1=\(color1.r)&g1=\(color1.g)&b1=\(color1.b)&r2=\(color1.r)&g2=\(color1.g)&b2=\(color1.b)", method: .get).responseJSON { (response) in
            _ = response.result
        }
    }
    
    func doubleColorCall(completed: @escaping completed){
        Alamofire.request("https://akshaybaweja.com/mood.php?request=set&HID=\(hardwareID)&r1=\(color1.r)&g1=\(color1.g)&b1=\(color1.b)&r2=\(color2.r)&g2=\(color2.g)&b2=\(color2.b)", method: .get).responseJSON { (response) in
            _ = response.result
        }
    }
    
    func randomColorCall(completed: @escaping completed){
        
        Alamofire.request("https://akshaybaweja.com/mood.php?request=set&HID=\(hardwareID)&r1=\(randomColor1.r)&g1=\(randomColor1.g)&b1=\(randomColor1.b)&r2=\(randomColor2.r))&g2=\(randomColor2.g)&b2=\(randomColor2.b)", method: .get).responseJSON { (response) in
            _ = response.result
        }
    }
    
    func getColor(color: UIColor)->color{
        var a : CGFloat = 0.0
        color.getRed(&tempColor.r, green: &tempColor.g, blue: &tempColor.b, alpha: &a)
        return tempColor
    }
    
  }


extension UIColor{
    var coreImageColor: CIColor{
        return CIColor(color:self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat){
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
}

