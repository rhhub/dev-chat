//
//  ViewController.swift
//  dev-chat
//
//  Created by Ryan Huebert on 10/6/16.
//  Copyright © 2016 Ryan Huebert. All rights reserved.
//

import UIKit
import FirebaseAuth

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
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        guard FIRAuth.auth()?.currentUser != nil else {
            // load login vc
            performSegue(withIdentifier: "LoginViewController", sender: nil)
            return
        }
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
    
    // CameraViewControllerDelegate
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
    
    func videoRecordingComplete(url: URL) {
        performSegue(withIdentifier: "UsersViewController", sender: url)
    }
    
    func videoRecordingFailed() {
        
    }
    
    func photoCaptureComplete(data: Data) {
        performSegue(withIdentifier: "UsersViewController", sender: data)
    }
    
    func photoCaptureFailed() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let usersViewController = segue.destination as? UsersViewController {
            
            if let url = sender as? URL {
                usersViewController.videoURL = url
            } else if let data = sender as? Data {
                usersViewController.photoData = data
            }
        }
    }
}

