//
//  PickerViewController.swift
//  Janeous
//
//  Created by SS21 on 09/03/18.
//

import UIKit
protocol pickerViewGetValue
{
    func pickerViewGetValue(pickerView:UIPickerView, withValue:Int)
}
class PickerViewController: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var pickerView: UIPickerView!
//    var pickerValue :[String] = [String]()
    var pickerValue = NSArray()
    var pickerViewGetValue:pickerViewGetValue!
    var tag:Int! = 0 //to indentify the picket value
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.tag = tag
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func cancelBtn(_ sender: UIButton) {
          self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtn(_ sender: UIButton)
    {
        self.dismiss(animated: true)
        {
            self.pickerViewGetValue.pickerViewGetValue(pickerView: self.pickerView, withValue: self.pickerView.selectedRow(inComponent: 0))
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValue.count
    }
    
    // Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerValue[row])"
    }

    
}
