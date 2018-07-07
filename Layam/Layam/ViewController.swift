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

    //Shruti Labels
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
    //UILabel Array
    @IBOutlet var shrutiUILabels:[UILabel]!
    
    //Swara Labels
    @IBOutlet weak var Swara_ma: UILabel!
    @IBOutlet weak var Swara_sa: UILabel!
    @IBOutlet weak var Swara_pa: UILabel!
    @IBOutlet weak var Swara_ni: UILabel!
    //Swara UILabel Array
    @IBOutlet var swaraUILabels:[UILabel]!

    
    //BPM Labels
    @IBOutlet weak var Bpm_70: UILabel!
    @IBOutlet weak var Bpm_80: UILabel!
    @IBOutlet weak var Bpm_90: UILabel!
    @IBOutlet weak var Bpm_100: UILabel!
    @IBOutlet weak var Bpm_110: UILabel!
    @IBOutlet weak var Bpm_120: UILabel!
    //BPM UILabel Array
    @IBOutlet var bpmUILabels:[UILabel]!
    
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var mridangaVolumeLevel: UILabel!
    @IBOutlet weak var shrutiVolumeLevel: UILabel!
    
    var tamburiSound: AVAudioPlayer?
    var mridangaSound: AVAudioPlayer?
    var shrutiSelected:String = "C"
    var swaraSelected = "sa"
    var bpmSelected = "80"
    var mridangamVolume:Float = 0.5
    var shrutiVolume:Float = 0.5
    
    @IBAction func mridangaVolumeChanged(_ sender: UISlider) {
        mridangamVolume = sender.value/sender.maximumValue
        let roundedNum = Int(mridangamVolume*100)
        mridangaVolumeLevel.text = String(roundedNum) + "%"
    }
    
    @IBAction func shrutiVolumeChanged(_ sender: UISlider) {
        shrutiVolume = sender.value/sender.maximumValue
        let roundedNum = Int(shrutiVolume*100)
        shrutiVolumeLevel.text = String(roundedNum) + "%"
        tamburiSound?.volume = shrutiVolume
    }
    
    //Audio actions
    @IBAction func PlayAudio(_ sender: Any) {
        
        let shrutiFileName = getShrutiFileName(shruti: shrutiSelected)
        let shrutiPath = Bundle.main.path(forResource: shrutiFileName, ofType:nil)!
        let shrutiUrl = URL(fileURLWithPath: shrutiPath)
        
        do {
            if(PlayButton.currentImage! == UIImage(named: "playbutton_sm.png")){
                tamburiSound = try AVAudioPlayer(contentsOf: shrutiUrl)
                tamburiSound?.numberOfLoops = -1
                tamburiSound?.volume = shrutiVolume
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
        
        
        //let mridangaFileName = getShrutiFileName(shruti: shrutiSelected)
        let mridangaFileName = "aditala_a_m_70.mp3"
        let mridangaPath = Bundle.main.path(forResource: mridangaFileName, ofType:nil)!
        let mridangaUrl = URL(fileURLWithPath: mridangaPath)
        
        do {
            if(PlayButton.currentImage! == UIImage(named: "playbutton_sm.png")){
                mridangaSound = try AVAudioPlayer(contentsOf: mridangaUrl)
                mridangaSound?.numberOfLoops = -1
                mridangaSound?.volume = mridangamVolume
                mridangaSound?.play()
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
        mridangaSound?.stop()
        
        PlayButton.setImage(UIImage(named: "playbutton_sm.png"), for: .normal)
    }
    
    //Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       
        setShrutiTapGestureRecognizer()
        setSwaraTapGestureRecognizer()
        setBpmTapGestureRecognizer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------- SHRUTI Functions ------------------------
    
    func setShrutiTapGestureRecognizer(){
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

    @objc func shrutiClick(_ gesture:UITapGestureRecognizer){
        //print("inside shruticlick")
        StopAudio(self)
        let shruti:UILabel = (gesture.view as! UILabel)
        //print("Clicked: \(shruti.text!)")
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
            fileName = "a_"+swaraSelected+".mp3"
            break
        case "A'":
            fileName = "as_"+swaraSelected+".mp3"
            break
        case "B":
            fileName = "b_"+swaraSelected+".mp3"
            break
        case "C":
            fileName = "c_"+swaraSelected+".mp3"
            break
        case "C'":
            fileName = "cs_"+swaraSelected+".mp3"
            break
        case "D":
            fileName = "d_"+swaraSelected+".mp3"
            break
        case "D'":
            fileName = "ds_"+swaraSelected+".mp3"
            break
        case "E":
            fileName = "e_"+swaraSelected+".mp3"
            break
        case "F":
            fileName = "f_"+swaraSelected+".mp3"
            break
        case "F'":
            fileName = "fs_"+swaraSelected+".mp3"
            break
        case "G":
            fileName = "g_"+swaraSelected+".mp3"
            break
        case "G'":
            fileName = "gs_"+swaraSelected+".mp3"
            break
        default:
            fileName = "c_sa.mp3"
            break
        }
        
        print("Shruti Filename: \(fileName)")
        return fileName
    }
    
    //---------------- SWARA Functions
    
    func setSwaraTapGestureRecognizer(){
        //Swara tap capturing
        Swara_sa.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(swaraClick(_:))))
        Swara_ma.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(swaraClick(_:))))
        Swara_pa.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(swaraClick(_:))))
        Swara_ni.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(swaraClick(_:))))
        
        Swara_sa.textColor = UIColor.red
    }
    
    
    @objc func swaraClick(_ gesture:UITapGestureRecognizer){
        //print("inside swaraclick")
        StopAudio(self)
        let swara:UILabel = (gesture.view as! UILabel)
        //print("Clicked: \(swara.text!)")
        swaraSelected = swara.text!
        swaraSelected = swaraSelected.lowercased()
        highlightSwara(swara)
    }
    
    func highlightSwara(_ selectedSwara:UILabel){
        
        for slabel in swaraUILabels{
            slabel.textColor=UIColor.white
        }
        
        selectedSwara.textColor=UIColor.red
    }
    
    //---------------- BPM Functions
    
    func setBpmTapGestureRecognizer(){
        //Swara tap capturing
        Bpm_70.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bpmClick(_:))))
        Bpm_80.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bpmClick(_:))))
        Bpm_90.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bpmClick(_:))))
        Bpm_100.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bpmClick(_:))))
        Bpm_110.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bpmClick(_:))))
        Bpm_120.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bpmClick(_:))))

        Bpm_80.textColor = UIColor.red
    }
    
    
    @objc func bpmClick(_ gesture:UITapGestureRecognizer){
        //print("inside bpmclick")
        StopAudio(self)
        let bpm:UILabel = (gesture.view as! UILabel)
        //print("Clicked: \(bpm!)")
        bpmSelected = bpm.text!
        bpmSelected = bpmSelected.lowercased()
        highlightSwara(bpm)
    }
    
    func highlightBpm(_ selectedBpm:UILabel){
        
        for blabel in bpmUILabels{
            blabel.textColor=UIColor.white
        }
        
        selectedBpm.textColor=UIColor.red
    }
    
   
}

