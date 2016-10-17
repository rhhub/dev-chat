//
//  CameraVCDelegate.swift
//  dev-chat
//
//  Created by Ryan Huebert on 10/11/16.
//  Copyright © 2016 Ryan Huebert. All rights reserved.
//

import Foundation

protocol  CameraViewControllerDelegate {
    func shouldEnableSwitchCameraButton (enabled: Bool)
    func shouldEnableRecordButton (enabled: Bool)
    func shouldEnablePhotoButton (enabled: Bool)
    func canStopRecording()
    func canStartRecording()
}
