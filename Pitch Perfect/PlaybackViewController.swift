//
//  PlaybackViewController.swift
//  Pitch Perfect
//
//  Created by Glenn Axworthy on 11/26/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

import UIKit
import AVFoundation

class PlaybackViewController: UIViewController {

    var model: AudioModel! = nil
    var engine: AVAudioEngine! = nil
    var player: AVAudioPlayerNode! = nil

    @IBOutlet weak var stopButton: UIButton!

    func playbackComplete() {
        dispatch_async(dispatch_get_main_queue(), {
            // only touch UIKit on main thread
            self.stopButton.enabled = false
        })
    }

    func playbackWithNode(node: AVAudioUnit) {
        stopButton.enabled = true

        if engine != nil {
            stopPlayback()
        } else {
            // configure and activate session once
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayback)
            try! session.setActive(true);
        }

        // release/recreate graph
        engine = AVAudioEngine()
        player = AVAudioPlayerNode()
        engine.attachNode(player)
        engine.attachNode(node) // engine owns node
        engine.connect(player, to: node, format: nil)
        engine.connect(node, to: engine.outputNode, format: nil)

        let file = try! AVAudioFile(forReading: model.fileURL)
        player.scheduleFile(file, atTime: nil, completionHandler: { self.playbackComplete() })

        try! engine.start()
        player.play()
    }

    func stopPlayback() {
        if engine != nil {
            player.stop()
            engine.stop()
            engine.reset()
        }
    }

    @IBAction func touchedChipmunkButton() {
        let timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = 2400 // maximum
        playbackWithNode(timePitch)
    }

    @IBAction func touchedFastButton() {
        let timePitch = AVAudioUnitTimePitch()
        timePitch.rate = 2.0
        playbackWithNode(timePitch)
    }

    @IBAction func touchedSlowButton() {
        let timePitch = AVAudioUnitTimePitch()
        timePitch.rate = 0.5
        playbackWithNode(timePitch)
    }

    @IBAction func touchedStopButton() {
        stopPlayback()
    }

    @IBAction func touchedVaderButton() {
        let timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = -2400 // minimum
        playbackWithNode(timePitch)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        if engine != nil {
            stopPlayback()

            let session = AVAudioSession.sharedInstance()
            try! session.setActive(false);
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stopButton.enabled = false // could use storyboard
    }
}
