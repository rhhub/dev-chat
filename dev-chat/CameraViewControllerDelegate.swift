//
//  CameraVCDelegate.swift
//  dev-chat
//
//  Created by Ryan Huebert on 10/11/16.
//  Copyright © 2016 Ryan Huebert. All rights reserved.
//

import Foundation

protocol  CameraVCDelegate {
    func shouldEnableCameraButton (enabled: Bool)
    func shouldEnableRecordButton (enagled: Bool)
    func canStopRecording()
    func canStartRecording()
}
