//
//  RecordViewController.swift
//  Pitch Perfect
//
//  Created by Glenn Axworthy on 11/26/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {

    var model: AudioModel! = nil
    var recorder: AVAudioRecorder! = nil

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var tapLabel: UILabel!

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully: Bool) {
        if successfully {
            performSegueWithIdentifier("PlaybackSegue", sender: nil)
        } else {
            // clean up and try again?
            self.recorder.deleteRecording()
            self.recorder = nil
            model = nil

            // controller remains visible
            recordButton.enabled = true
            recordingLabel.hidden = true
            stopButton.hidden = true
            tapLabel.hidden = false
        }

        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let playbackController = segue.destinationViewController as! PlaybackViewController
        playbackController.model = model // supply model to playback controller
    }

    @IBAction func touchedRecordButton() {
        recordButton.enabled = false
        recordingLabel.hidden = false
        stopButton.hidden = false
        tapLabel.hidden = true

        // configure and activate audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryRecord)
        try! session.setActive(true)
        
        // create model for recording
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let fileName = formatter.stringFromDate(date) + ".wav"
        let fileURL = NSURL.fileURLWithPathComponents([path, fileName])
        model = AudioModel(fileName: fileName, fileURL: fileURL!)
        
        try! recorder = AVAudioRecorder(URL: fileURL!, settings: [:])
        recorder.delegate = self
        recorder.meteringEnabled = true
        recorder.record()
    }
    
    @IBAction func touchedStopButton() {
        recordButton.enabled = false
        recordingLabel.hidden = true
        stopButton.enabled = false
        tapLabel.hidden = true

        recorder.stop() // triggers segue
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // could do this in storyboard
        recordButton.enabled = true
        recordButton.hidden = false
        recordingLabel.hidden = true
        stopButton.enabled = true
        stopButton.hidden = true
        tapLabel.hidden = false
    }
}

