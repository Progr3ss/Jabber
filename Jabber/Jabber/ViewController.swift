//
//  ViewController.swift
//  Jabber
//
//  Created by martin chibwe on 12/13/16.
//  Copyright © 2016 Martin Chibwe. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController{

	override func viewDidLoad() {
		super.viewDidLoad()
		 //AVSpeechSynthesisVoice
		//var voiceToUse: AVSpeechSynthesisVoice?
		/*
		let utterance = AVSpeechUtterance(string: "como estas")
		utterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
		utterance.rate = 0.4
		
		let synthesizer = AVSpeechSynthesizer()
		synthesizer.speak(utterance)
		*/
		

		
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func startRecording(_ sender: Any) {
		var voiceToUse: AVSpeechSynthesisVoice?
		for voice in AVSpeechSynthesisVoice.speechVoices() {
			if #available(iOS 9.0, *) {
				print(voice)
				
				if voice.name == "Samantha"{
					
					voiceToUse = voice
				}
				
				
			}
			
			
			
		}
		
	
		
		
		let utterance = AVSpeechUtterance(string: "Hello from iOS.")
		utterance.voice = voiceToUse
		utterance.rate = 0.5
		let synth = AVSpeechSynthesizer()
		synth.speak(utterance)
	}

	@IBAction func stopRecording(_ sender: Any) {
	}
}

