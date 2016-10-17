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
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    
    override func viewDidLoad() {
        delegate = self
        self._previewView = previewView
        
        // Enable dummy UI to prevent crashes.
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        toggleMovieRecording(sender)
    }
    
    @IBAction func switchCameraButtonPressed(_ sender: UIButton) {
        changeCamera(sender)
    }
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
        capturePhoto(sender)
    }
    
    
    func shouldEnableSwitchCameraButton(enabled: Bool) {
        switchCameraButton.isEnabled = enabled
        print("Should enable switchCameraButton: \(enabled)")
    }
    
    func shouldEnableRecordButton(enabled: Bool) {
        recordButton.isEnabled = enabled
        print("Should enable recordButton: \(enabled)")
    }
    
    func shouldEnablePhotoButton(enabled: Bool) {
        photoButton.isEnabled = enabled
        print("Should enable pictureButton: \(enabled)")
    }
    
    func canStopRecording() {
        print("Recording has started")
    }
    
    func canStartRecording() {
        print("Can start recording")
    }
}

