//
//  ViewController.swift
//  Layam
//
//  Created by Prasanna Ramaswamy on 28/12/17.
//  Copyright © 2017 Abheri. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var Shruti_a: UILabel!
    @IBOutlet weak var Shruti_as: UILabel!
    @IBOutlet weak var Shruti_b: UILabel!
    @IBOutlet weak var Shruti_c: UILabel!
    @IBOutlet weak var Shruti_cs: UILabel!
    @IBOutlet weak var Shruti_d: UILabel!
    @IBOutlet weak var Shruti_ds: UILabel!
    @IBOutlet weak var Shruti_e: UILabel!
    @IBOutlet weak var Shruti_f: UILabel!
    @IBOutlet weak var Shruti_fs: UILabel!
    @IBOutlet weak var Shruti_g: UILabel!
    @IBOutlet weak var Shruti_gs: UILabel!
    
    @IBOutlet var shrutiUILabels:[UILabel]!
    
    @IBOutlet weak var PlayButton: UIButton!
    
    var tamburiSound: AVAudioPlayer?
    var shrutiSelected:String = "C"
    
    //Audio actions
    @IBAction func PlayAudio(_ sender: Any) {
        
        let fileName = getShrutiFileName(shruti: shrutiSelected)
        
        let path = Bundle.main.path(forResource: fileName, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            if(PlayButton.currentImage! == UIImage(named: "playbutton_sm.png")){
                tamburiSound = try AVAudioPlayer(contentsOf: url)
                tamburiSound?.numberOfLoops = -1
                tamburiSound?.play()
                PlayButton.setImage(UIImage(named: "pause_sm.png"), for: .normal)
            }else{
                StopAudio(sender)
                //tamburiSound?.stop()
                //PlayButton.setImage(UIImage(named: "playbutton_sm.png"), for: .normal)
            }
        } catch {
            // couldn't load file :(
        }
    }
    func StopAudio(_ sender: Any) {
        tamburiSound?.stop()
        PlayButton.setImage(UIImage(named: "playbutton_sm.png"), for: .normal)
    }
    
    //Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Shruti tap capturing
        Shruti_a.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shrutiClick(_:))))
        Shruti_as.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shrutiClick(_:))))
        Shruti_b.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shrutiClick(_:))))
        Shruti_c.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shrutiClick(_:))))
        Shruti_cs.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shrutiClick(_:))))
        Shruti_d.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shrutiClick(_:))))
        Shruti_ds.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shrutiClick(_:))))
        Shruti_e.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shrutiClick(_:))))
        Shruti_f.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shrutiClick(_:))))
        Shruti_fs.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shrutiClick(_:))))
        Shruti_g.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shrutiClick(_:))))
        Shruti_gs.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shrutiClick(_:))))
        
        Shruti_c.textColor = UIColor.red
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func shrutiClick(_ gesture:UITapGestureRecognizer){
        print("inside shruticlick")
        StopAudio(self)
        let shruti:UILabel = (gesture.view as! UILabel)
        print("Clicked: \(shruti.text!)")
        shrutiSelected = shruti.text!
        highlightShruti(shruti)
    }
    
    func highlightShruti(_ selectedShruti:UILabel){
        
        for slabel in shrutiUILabels{
            slabel.textColor=UIColor.white
        }
        
        selectedShruti.textColor=UIColor.red
    }
    
    func getShrutiFileName(shruti:String)->String{
        var fileName:String="c_sa.mp3";
        
        switch(shruti.trimmingCharacters(in: .whitespaces)){
        case "A":
            fileName = "a_sa.mp3"
            break
        case "A'":
            fileName = "as_sa.mp3"
            break
        case "B":
            fileName = "b_sa.mp3"
            break
        case "C":
            fileName = "c_sa.mp3"
            break
        case "C'":
            fileName = "cs_sa.mp3"
            break
        case "D":
            fileName = "d_sa.mp3"
            break
        case "D'":
            fileName = "ds_sa.mp3"
            break
        case "E":
            fileName = "e_sa.mp3"
            break
        case "F":
            fileName = "f_sa.mp3"
            break
        case "F'":
            fileName = "fs_sa.mp3"
            break
        case "G":
            fileName = "g_sa.mp3"
            break
        case "G'":
            fileName = "gs_sa.mp3"
            break
        default:
            fileName = "c_sa.mp3"
            break
        }
        
        return fileName
    }
}

