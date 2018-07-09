//
//  ViewController.swift
//  Layam
//
//  Created by Prasanna Ramaswamy on 28/12/17.
//  Copyright © 2017 Abheri. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    

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
    
    @IBOutlet weak var TalaTableView: UITableView!
    @IBOutlet weak var KalaSwitch: UISwitch!
    @IBOutlet weak var KalaLabel: UILabel!
    
    
    var talaList = ["Aditala","Rupakatala", "Mishrachapu", "Khandachapu",
                    "Aditala Mohra Korvai", "Rupakatala Mohra Korvai",
                    "Mishrachapu Mohra Korvai", "Khandachapu Mohra Korvai"]
    var kalaMap = ["Madhyama":"m", "Vilamba":"v"]
    
    let cellReuseIdentifier = "table_cell"
    
    var tamburiSound: AVAudioPlayer?
    var mridangaSound: AVAudioPlayer?
    var talaSelected = "aditala"
    var shrutiSelected:String = "C"
    var swaraSelected = "sa"
    var kalaSelected = "m"
    var bpmSelected = "80"
    var mridangamVolume:Float = 0.5
    var shrutiVolume:Float = 0.5
    var audioPlaying:Bool = false
    
    var shrutiMapping = ["A":"a", "A'":"as", "B":"b", "C":"c", "C'":"cs", "D":"d",
                         "D'":"ds", "E":"e", "F":"f", "F'":"fs", "G":"g", "G'":"gs"];
    
    //Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Register the table view cell class and its reuse id
        self.TalaTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        // This view controller itself will provide the delegate methods and row data for the table view.
        TalaTableView.delegate = self
        TalaTableView.dataSource = self
   

        
        let index = NSIndexPath(row: 0, section: 0)
        TalaTableView.selectRow(at: index as IndexPath, animated: false, scrollPosition: UITableViewScrollPosition.top)
        KalaSwitch.setOn(false, animated: false)
        
        setShrutiTapGestureRecognizer()
        setSwaraTapGestureRecognizer()
        setBpmTapGestureRecognizer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //--------------- AUDIO FUNCTIONS --------------------------
    @IBAction func mridangaVolumeChanged(_ sender: UISlider) {
        mridangamVolume = sender.value/sender.maximumValue
        let roundedNum = Int(mridangamVolume*100)
        mridangaVolumeLevel.text = String(roundedNum) + "%"
        mridangaSound?.volume = mridangamVolume
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
        
        let mridangaFileName = getTalaFileName(tala: talaSelected)
        //let mridangaFileName = "aditala_a_m_70.mp3"
        let mridangaPath = Bundle.main.path(forResource: mridangaFileName, ofType:nil)!
        let mridangaUrl = URL(fileURLWithPath: mridangaPath)
        
        do {
            tamburiSound = try AVAudioPlayer(contentsOf: shrutiUrl)
            mridangaSound = try AVAudioPlayer(contentsOf: mridangaUrl)
            
            if(!audioPlaying){
                tamburiSound?.numberOfLoops = -1
                tamburiSound?.volume = shrutiVolume
                tamburiSound?.play()
                
                
                mridangaSound?.numberOfLoops = -1
                mridangaSound?.volume = mridangamVolume
                mridangaSound?.play()
                
                audioPlaying = true
                PlayButton.setImage(UIImage(named: "pause_sm.png"), for: .normal)
            }else{
                StopAudio(sender)
            }
        } catch {
            // couldn't load file :(
        }
        
    }
    func StopAudio(_ sender: Any) {
        tamburiSound?.stop()
        mridangaSound?.stop()
        
        audioPlaying = false
        PlayButton.setImage(UIImage(named: "playbutton_sm.png"), for: .normal)
    }
    //--------------- KALA SWITCH ---------------------------
    
    @IBAction func KalaChanged(_ sender: Any) {
        if(KalaSwitch.isOn){
            kalaSelected = "Vilamba"
        }else{
            kalaSelected = "Madhyama"
        }
        
        KalaLabel.text = kalaSelected
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
        shrutiSelected = shruti.text!.trimmingCharacters(in: .whitespaces)
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
        
        fileName = shrutiMapping[shruti]!+"_"+swaraSelected+".mp3"
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
        highlightBpm(bpm)
    }
    
    func highlightBpm(_ selectedBpm:UILabel){
        
        for blabel in bpmUILabels{
            blabel.textColor=UIColor.white
        }
        
        selectedBpm.textColor=UIColor.red
    }
    
    // --- TABLE FUNCTIONS

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return talaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = (self.TalaTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        
        // set the text from the data model
        cell.textLabel?.text = self.talaList[indexPath.row]
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You tapped cell number \(indexPath.row).")
        talaSelected = self.talaList[indexPath.row]
        StopAudio(self)
    }
    
    func getTalaFileName(tala:String)->String{
        var fileName:String="aditala_c_m_80.mp3";
        let shruti = shrutiMapping[shrutiSelected]!
        let kala = kalaMap[kalaSelected]
        
        switch(tala.trimmingCharacters(in: .whitespaces)){
        case "Aditala":
            fileName = "aditala_\(shruti)_\(String(describing: kala))_\(bpmSelected).mp3"
            break
        case "Rupakatala":
            fileName = "rupakatala_\(shruti)_\(String(describing: kala))_\(bpmSelected).mp3"
            break
        case "Mishrachapu":
            fileName = "mishrachapu_\(shruti)_\(String(describing: kala))_\(bpmSelected).mp3"
            break
        case "Khandachapu":
            fileName = "khandachapu_\(shruti)_\(String(describing: kala))_\(bpmSelected).mp3"
            break
        case "Aditala Mohra Korvai":
            fileName = "aditala_mohra_korvai.mp3"
            break
        case "Rupakatala Mohra Korvai":
            fileName = "rupakatala_mohra_korvai.mp3"
            break
        case "Mishrachapu Mohra Korvai":
            fileName = "mishrachapu_mohra_korvai.mp3"
            break
        case "Khandachapu Mohra Korvai":
            fileName = "khandachapu_mohra_korvai.mp3"
            break
        default:
            fileName = "aditala_c_m_80.mp3"
            break
        }
        
        print("Shruti Filename: \(fileName)")
        return fileName
    }
    
}

