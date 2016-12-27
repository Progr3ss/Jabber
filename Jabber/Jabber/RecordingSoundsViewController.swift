//
//  RecordingSoundsViewController.swift
//  Jabber
//
//  Created by martin chibwe on 12/16/16.
//  Copyright © 2016 Martin Chibwe. All rights reserved.
//

import UIKit
import Speech

class RecordingSoundsViewController: UIViewController{
	
	private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
	
	private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
	
	private var recognitionTask: SFSpeechRecognitionTask?
	
	private let audioEngine = AVAudioEngine()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	func setUpSpeech()  {
		
		
	
	}
    



}
