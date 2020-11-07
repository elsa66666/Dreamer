//
//  SpeechRecognitionViewController.swift
//  dreamer1
//
//  Created by Elsa on 2020/8/31.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit
import Speech

class SpeechRecognitionViewController: UIViewController, SFSpeechRecognizerDelegate, UITextViewDelegate{
    
    //var jumpDiary: Jump?
    let audioEngine = AVAudioEngine()
    var speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var task: SFSpeechRecognitionTask!
    var isStarted: Bool = false
    var speechArray:[String] = []
    var message:String = ""
    var isEnded: Bool = true
    
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var languageChoose: UISegmentedControl!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var recordStateLabel: UILabel!
    @IBOutlet weak var speechButton: UIButton!
    @IBOutlet weak var tipLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speechButton.layer.cornerRadius = 20
        requestPermission()
        recordStateLabel.text = "⬅️click to start"
        messageTextView.text = ""
        responseLabel.text =
        """
        You can try to say to me:
        \"write a diary\"
        \"view data\"
        \"view dreams\"
        \"new dream\"
        """
        tipLabel.text = ""
        messageTextView.delegate = self
        //jumpDiary = Test.jumpD
        }
    
    @IBAction func languageChanged(_ sender: UISegmentedControl) {
        chooseLanguage()
    }
    
    @IBAction func toHome(_ sender: Any) {
        let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        let VCMain = mainBoard!.instantiateViewController(withIdentifier: "vcMain")
        UIApplication.shared.windows[0].rootViewController = VCMain
    }
    
    
    // MARK: -speech recognition

    @IBAction func speechButtonPressed(_ sender: UIButton) {
        isStarted = !isStarted
        chooseLanguage()
        if isStarted{
            isEnded = false
            startSpeechRecognition()
            recordStateLabel.text = "Recording..."
            speechButton.backgroundColor = #colorLiteral(red: 0.837902844, green: 0.7066189647, blue: 0.8254889846, alpha: 0.939741291)
        }else{
            isEnded = true
            stopSpeechRecognition()
            recordStateLabel.text = "⬅️click to start"
            speechButton.backgroundColor = #colorLiteral(red: 0.4338570833, green: 0.2872386575, blue: 0.5238974094, alpha: 1)
        }
    }
     
    func requestPermission() {
        self.speechButton.isEnabled = false
        SFSpeechRecognizer.requestAuthorization { (authState) in
            OperationQueue.main.addOperation {
                if authState == .authorized{
                    self.speechButton.isEnabled = true
                    print("允许使用麦克风")
                }else if authState == .denied{
                    self.speechButton.isEnabled = false
                }
            }
        }
    }
    
    func startSpeechRecognition(){
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch _{
            print("cannot start the audio engine")
        }
        
        guard let myRecognition = SFSpeechRecognizer() else {
            return
        }
        if !myRecognition.isAvailable {
            print("recognition not available")
        }
        
        task = speechRecognizer?.recognitionTask(with: request, resultHandler: { (response, error) in
            guard let response = response else{
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
                return
            }
            self.message = response.bestTranscription.formattedString
            self.messageTextView.text = self.message
        })
    }
    
    func stopSpeechRecognition(){
        self.speechArray.append(self.message)
        print(self.speechArray)
        task.finish()
        task.cancel()
        task = nil
        
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)

        setTipLabelText()
        judgeAndResponse()
    }
    
    // MARK: -judge and response
    
    func judgeAndResponse(){
        
        switch languageChoose.selectedSegmentIndex {
        case 0:  //英语
            if message.contains("write a diary"){
                let time: TimeInterval = 1.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time){
                    self.dismiss(animated: true, completion: nil)
                    //self.jumpDiary?.jumpDream()
                }
            }else if message.contains("view data"){
                let time: TimeInterval = 1.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time){
                    self.dismiss(animated: true, completion: nil)
                    //self.jumpDiary?.jumpStatics()
                }
            }else if message.contains("view dreams"){
                let time: TimeInterval = 1.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time){
                    self.dismiss(animated: true, completion: nil)
                    //self.jumpDiary?.jumpDream()
                }
            }else if message.contains("add new dream"){
                let time: TimeInterval = 1.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time){
                    self.dismiss(animated: true, completion: nil)
                    //self.jumpDiary?.jumpNewDiary()
                }
            }else{
                responseLabel.text = "Sorry, I may not understand you."
            }

        case 1:
            speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "zh-CN"))
            if message.contains("写日记"){
            //let pattern1 = "^(\\写)+(\\日,\\记)+$"
            //let regex = try? NSRegularExpression(pattern: pattern1, options: [])
            //if let results = regex?.matches(in: message, options: [], range: NSRange(location: 0, length: message.count)), results.count != 0 {
                let time: TimeInterval = 1.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time){
                    print("识别出：写日记")
                    self.dismiss(animated: true, completion: nil)
                    //self.jumpDiary?.jumpDream()
                }
            }else if message.contains("查看数据"){
                let time: TimeInterval = 1.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time){
                    self.dismiss(animated: true, completion: nil)
                    //self.jumpDiary?.jumpStatics()
                }
            }else if message.contains("查看梦想"){
                let time: TimeInterval = 1.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time){
                    self.dismiss(animated: true, completion: nil)
                    //self.jumpDiary?.jumpDream()
                }
            }else if message.contains("新建梦想"){
                let time: TimeInterval = 1.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time){
                    self.dismiss(animated: true, completion: nil)
                    //self.jumpDiary?.jumpNewDiary()
                }
            }else{
                responseLabel.text = "我好像听不懂你在说什么。"
            }

        case 2:
            speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "fr-FR"))
            if message.contains("Écris un journal"){
                let time: TimeInterval = 1.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time){
                    self.dismiss(animated: true, completion: nil)
                    //self.jumpDiary?.jumpDream()
                }
            }else if message.contains("Données"){
                let time: TimeInterval = 1.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time){
                    self.dismiss(animated: true, completion: nil)
                    //self.jumpDiary?.jumpStatics()
                }
            }else if message.contains("Rêve"){
                let time: TimeInterval = 1.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time){
                    self.dismiss(animated: true, completion: nil)
                    //self.jumpDiary?.jumpDream()
                }
            }else if message.contains("Nouveau rêve"){
                let time: TimeInterval = 1.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time){
                    self.dismiss(animated: true, completion: nil)
                    //self.jumpDiary?.jumpNewDiary()
                }
            }else{
                responseLabel.text = "Je ne comprends pas."
            }

        default:
            speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "de-DE"))
            if message.contains("Schreiben Sie ein Tagebuch im Bereich der Kombiwette"){
                let time: TimeInterval = 1.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time){
                    self.dismiss(animated: true, completion: nil)
                    //self.jumpDiary?.jumpDream()
                }
            }else if message.contains("Daten anzeigen"){
                let time: TimeInterval = 1.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time){
                    self.dismiss(animated: true, completion: nil)
                    //self.jumpDiary?.jumpStatics()
                }
            }else if message.contains("Sehen Sie Träume"){
                let time: TimeInterval = 1.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time){
                    self.dismiss(animated: true, completion: nil)
                    //self.jumpDiary?.jumpDream()
                }
            }else if message.contains("Neuer Traum"){
                let time: TimeInterval = 1.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time){
                    self.dismiss(animated: true, completion: nil)
                    //self.jumpDiary?.jumpNewDiary()
                }
            }else{
                responseLabel.text = "Ich verstehe dich vielleicht nicht."
            }
        }
    }
    // MARK: -set response label default
    func chooseLanguage(){
        switch languageChoose.selectedSegmentIndex {
        case 0:
            speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
            responseLabel.text =
            """
            You can try to say to me:
            \"write a diary\"
            \"view data\"
            \"view dreams\"
            \"add new dream\"
            """
        case 1:
            speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "zh-CN"))
            responseLabel.text =
            """
            你可以试试对我说:
            \"写日记\"
            \"查看数据\"
            \"查看梦想\"
            \"新建梦想\"
            """
        case 2:
            speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "fr-FR"))
            responseLabel.text =
            """
            Tu peux essayer de me dire:
            \"Écris un journal\"
            \"Données\"
            \"Rêve\"
            \"Nouveau rêve\"
            """
        default:
            speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "de-DE"))
            responseLabel.text =
            """
            Sie können versuchen, mir zu sagen:
            \"Schreiben Sie ein Tagebuch im Bereich der Kombiwette\"
            \"Daten anzeigen\"
            \"Sehen Sie Träume\"
            \"Neuer Traum\"
            """
        }
    }
    
    func setTipLabelText(){
        switch languageChoose.selectedSegmentIndex {
        case 0: //英
            tipLabel.text = "Tap the text box to edit."
        case 1: //中
            tipLabel.text = "轻触文本框即可编辑."
        case 2: //法
            tipLabel.text = "Cliquez sur la zone de texte pour éditer."
        default: //德
            tipLabel.text = "Tippen Sie auf das Textfeld."
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        message = messageTextView.text
        judgeAndResponse()
    }
}
