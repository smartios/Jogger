//
//  SelectImageViewController.swift
//  Janeous
//
//  Created by singsys on 21/03/18.
//

import UIKit

protocol selectImageSourceDelegate
{
    func selectImageSourceDelegate(tag:Int)
}
class SelectImagePopUpViewController: UIViewController {

     @IBOutlet var galleryButton:UIButton!
     @IBOutlet var cameraButton:UIButton!
    
    var selectImageSourceDelegate:selectImageSourceDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sourceButtonClicked(sender:UIButton)
    {
        
        self.dismiss(animated: true) {
             self.selectImageSourceDelegate.selectImageSourceDelegate(tag: sender.tag)
        }
    }
    
    @IBAction func cancelButtonClicked(sender:UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
