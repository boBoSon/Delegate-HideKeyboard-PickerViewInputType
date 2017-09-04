//
//  ViewController.swift
//  DelegateTest
//
//  Created by 邱柏盛 on 2017/9/4.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CarDelegate {
    @IBOutlet weak var redCarLbl: UILabel!
    @IBOutlet weak var orangeCarLbl: UILabel!
    @IBOutlet weak var yellowCarLbl: UILabel!
    @IBOutlet weak var greenCarLbl: UILabel!
    @IBOutlet weak var blueCarLbl: UILabel!
    @IBOutlet weak var purpleCarLbl: UILabel!


    @IBOutlet weak var tf: UITextField!
    @IBOutlet weak var stepLbl: UILabel!
    // 在 PickerView 中的選項
    let oneToSixArray = [1, 2, 3, 4, 5, 6]
    let oneToSixPickerView = UIPickerView()
    
    
    var redCar = Car.init()
    var orangeCar = Car.init()
    var yellowCar = Car.init()
    var greenCar = Car.init()
    var blueCar = Car.init()
    var purpleCar = Car.init()
    
    // 包住 VC 中所有的 Car, 之後可以依 index 抓到指定的 car
    var carArray = [Car]()
    // 包住畫面中所有的的 Lbl, 同上
    var lblArray = [UILabel]()
    var carIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carArray = [redCar, orangeCar, yellowCar, greenCar, blueCar, purpleCar]
        
        lblArray = [redCarLbl, orangeCarLbl, yellowCarLbl, greenCarLbl, blueCarLbl, purpleCarLbl]
        
        // 將所有 delegate 指定給自己 (vc)
        for car in carArray {
            car.delegate = self
        }
        tf.delegate = self
        oneToSixPickerView.delegate = self
        
        // 讓鍵盤變成 PickerView 的形式
        tf.inputView = oneToSixPickerView
        tf.text = "\(carIndex + 1)"
        
        
        // 設定鍵盤彈出與收起的通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        hideKeyboard()
        
    }
    
    // 讓特定的車子往前走
    @IBAction func specificCarMove(_ sender: UIButton) {
        
        carArray[carIndex].go()
        
        
    }
    
    // 點隨意一處收鍵盤
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        self.view.addGestureRecognizer(tap)
    }
    // 收鍵盤
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    
    
    
    
    
    // MARK: TextFieldDelegate Methods
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let index = Int(textField.text!) else {
            return
        }
        // 更新 carIndex
        carIndex = index - 1
        // 更新 stepLbl
        stepLbl.text = "\(carArray[carIndex].steps)"
    }
    
    // MARK: UIPickerViewDelegate & UIPickerViewDataSource
    // 幾行
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // 每行幾列
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return oneToSixArray.count
    }
    // 每列顯示的字
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(oneToSixArray[row])
    }
    // 選了第幾行第幾列以後要做什麼
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 在畫面上顯示現在選的是第幾台車
        tf.text = String(oneToSixArray[row])
    }
    
    // MARK: CarDelegate Methods
    func moveForwardOnScreen(car: Car) {
        // 原本車子的位置
        let originalFrame = lblArray[carIndex].frame
        // 讓車子往前走
        lblArray[carIndex].frame = CGRect.init(x: originalFrame.maxX, y: originalFrame.minY, width: originalFrame.width, height: originalFrame.height)
        // 更新車子的步數
        stepLbl.text = "\(car.steps)"
    }
    
    
    // MARK: Notification Methods
    // 鍵盤出現時抬升畫面
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    // 鍵盤消失時下降畫面
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

