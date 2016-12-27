//
//  ConversationBetweenTwoPeople.swift
//  Jabber
//
//  Created by martin chibwe on 12/19/16.
//  Copyright © 2016 Martin Chibwe. All rights reserved.
//

import UIKit

import Speech

class ConversationBetweenTwoPeople: UIViewController, SFSpeechRecognizerDelegate {
	
	@IBOutlet var recordButton : UIButton!
	@IBOutlet var firstPersonConversation: UITextView!
	@IBOutlet var secondPersonConverstion: UITextView!
	var voiceToUse: AVSpeechSynthesisVoice?
	private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en"))!
	private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
	
	private var recognitionTask: SFSpeechRecognitionTask?
	
	private let audioEngine = AVAudioEngine()
    override func viewDidLoad() {
        super.viewDidLoad()
	
		recordButton.isEnabled = false
		print("ViewWord \(firstPersonConversation)")
		
		
		self.textToSpeech(text: "Hello This is Chibwe")
		//textToSpeech(text: "Hello Wrold")

        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		
		speechRecognizer.delegate = self
		
		SFSpeechRecognizer.requestAuthorization { authStatus in
			/*
			The callback may not be called on the main thread. Add an
			operation to the main queue to update the record button's state.
			*/
			OperationQueue.main.addOperation {
				switch authStatus {
				case .authorized:
					self.recordButton.isEnabled = true
					
				case .denied:
					self.recordButton.isEnabled = false
					self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
					
				case .restricted:
					self.recordButton.isEnabled = false
					self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
					
				case .notDetermined:
					self.recordButton.isEnabled = false
					self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
				}
			}
			

		}
	}
	

	
	private func startRecording() throws {
		
		// Cancel the previous task if it's running.
		if let recognitionTask = recognitionTask {
			recognitionTask.cancel()
			self.recognitionTask = nil
		}
	
		let audioSession = AVAudioSession.sharedInstance()
		try audioSession.setCategory(AVAudioSessionCategoryRecord)
		try audioSession.setMode(AVAudioSessionModeMeasurement)
		try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
		
		recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
		
		guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
		guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
		
		// Configure request so that results are returned before audio recording is finished
		recognitionRequest.shouldReportPartialResults = false
		
		// A recognition task represents a speech recognition session.
		// We keep a reference to the task so that it can be cancelled.
		recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
			var isFinal = false
			
			if let result = result {
				self.firstPersonConversation.text = result.bestTranscription.formattedString
				isFinal = result.isFinal
				print("Words \(self.firstPersonConversation.text!)")
			
				
			
			}
			
			if error != nil || isFinal {
				self.audioEngine.stop()
				inputNode.removeTap(onBus: 0)
				
				self.recognitionRequest = nil
				self.recognitionTask = nil
				
				self.recordButton.isEnabled = true
				self.recordButton.setTitle("Start Recording", for: [])
			}
			
			
		}
		
		let recordingFormat = inputNode.outputFormat(forBus: 0)
		
		inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
			self.recognitionRequest?.append(buffer)
		}
		
		
		audioEngine.prepare()
		
		try audioEngine.start()
		
		firstPersonConversation.text = "(Go ahead, I'm listening)"
	}
	// MARK: SFSpeechRecognizerDelegate
	
	public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
		if available {
			recordButton.isEnabled = true
			recordButton.setTitle("Start Recording", for: [])
		} else {
			recordButton.isEnabled = false
			recordButton.setTitle("Recognition not available", for: .disabled)
		}
	}
	
	@IBAction func testButton(_ sender: Any) {
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
	
	@IBAction func recordingButtonTapped(_ sender: Any) {
		

	
		if audioEngine.isRunning {
			audioEngine.stop()
			recognitionRequest?.endAudio()
			recordButton.isEnabled = false
			recordButton.setTitle("Stopping", for: .disabled)
			
			
		} else {
			try! startRecording()
			recordButton.setTitle("Stop recording", for: [])
			
		}
		

	}
	
	func textToSpeech(text: String)  {
		

		let utterance = AVSpeechUtterance(string: text)
		utterance.voice = voiceToUse
		utterance.rate = 0.4
		let synth = AVSpeechSynthesizer()
		synth.speak(utterance)
		print("Text IS \(text)")
		print("textToSpeech")
		
		
	}
	


}
