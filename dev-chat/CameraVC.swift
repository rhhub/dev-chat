//
//  ViewController.swift
//  dev-chat
//
//  Created by Ryan Huebert on 10/6/16.
//  Copyright © 2016 Ryan Huebert. All rights reserved.
//

import UIKit

class CameraVC: CameraViewController, CameraViewControllerDelegate{

    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var changeCameraBtn: UIButton!
    
    override func viewDidLoad() {
        delegate = self
        self._previewView = previewView
        
        // Enable dummy UI to prevent crashes.
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    @IBAction func recordBrnPressed(_ sender: UIButton) {
        toggleMovieRecording(sender)
    }
    
    
    @IBAction func changeCameraBrnPressed(_ sender: UIButton) {
        changeCamera(sender)
    }
    
    func shouldEnableCameraButton(enabled: Bool) {
        changeCameraBtn.isEnabled = enabled
        print("Should enable Camera Button: \(enabled)")
    }
    
    func shouldEnableRecordButton(enabled: Bool) {
        recordBtn.isEnabled = enabled
        print("Should enable Record Button: \(enabled)")
    }
    
    func canStopRecording() {
        print("Recording has started")
    }
    
    func canStartRecording() {
        print("Can start recording")
    }
}

