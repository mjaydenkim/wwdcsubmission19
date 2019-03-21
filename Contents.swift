import UIKit
import PlaygroundSupport
import AVFoundation

class MyViewController : UIViewController, AVAudioPlayerDelegate {
    var label: UILabel!
    var scoreLabel: UILabel!
    var score: Int! = 0
    var simon: String! = ""
    var checkStr: String! = ""
    var button: UIButton!
    var audioPlayer = AVAudioPlayer()
    let icon = UIImage(named: "check2.png")! //from ionicons
    let icon2 = UIImage(named: "restart.png")! //also from ionicons
    let font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
    let synth = AVSpeechSynthesizer()
    func speak(utterance: AVSpeechUtterance){
        synth.speak(utterance)
    }
    @objc func restartGame() {
        button.removeTarget(self, action: #selector(restartGame), for: .touchUpInside)
        button.addTarget(self, action: #selector(check), for: .touchUpInside)
        simon = ""
        checkStr = ""
        score = 0
        button.setImage(icon, for: .normal)
        label.text = "To play, make the gestures that the app speaks and then press the green check when you are done."
        scoreLabel.text = "Your score is " + String(score)
        let v1: String! = randomizeSimon(RemoveChar: "")
        checkStr = checkStr + v1 + randomizeSimon(RemoveChar: v1)
        let arr = checkStr.map { String($0) }
        for char in arr! {
            playGestures(c: char)
        }

    }
    override func viewDidLoad() {
        view.backgroundColor = UIColor(red: 186/255.0, green: 198/255.0, blue: 196/255.0, alpha: 1.0)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        label = UILabel(frame: .init(x: 0, y: 0, width: 200, height: 200))
        label.textAlignment = .center
        label.text = "To play, make the gestures that the app speaks and then press the green check when you are done."
        label.numberOfLines = 0
        label.font = font
        label.center = CGPoint(x: 210, y: 300)
        label.textColor = UIColor(red:102/255, green: 121/255, blue: 118/255, alpha: 1.0)
        view.addSubview(self.label)
        scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        scoreLabel.font = font
        scoreLabel.center = CGPoint(x: 210, y: 500)
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = UIColor(red: 52/250, green: 80/250, blue: 96/250, alpha: 1.0)
        scoreLabel.text = "Your score is " + String(score)
        view.addSubview(self.scoreLabel)
        button = UIButton(frame: CGRect(x: 210, y: 210, width: 200, height: 100))
        button.backgroundColor = UIColor(red: 40/255.0, green: 130/255.0, blue: 178/255.0, alpha: 1.0)
        button.center = self.view.center
        button.layer.cornerRadius = self.button.frame.height/2
        button.center = CGPoint(x: 210, y: 600)
        button.layer.shadowOpacity = 0.25
        button.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 0, height: 7)
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(check), for: .touchUpInside)
        view.addSubview(self.button)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        view.addGestureRecognizer(tap)
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
        view.addGestureRecognizer(pinch)
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(sender:)))
        view.addGestureRecognizer(rotate)
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        view.addGestureRecognizer(swipe)
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap(sender:)))
        view.addGestureRecognizer(longTap)
        let v1: String! = randomizeSimon(RemoveChar: "")
        checkStr = checkStr + v1 + randomizeSimon(RemoveChar: v1)
        let arr = checkStr.map { String($0) }
        for char in arr! {
            playGestures(c: char)
        }
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    @objc func handleTap(sender:UITapGestureRecognizer) {
        simon = simon + "T"
    }
    @objc func handlePinch(sender:UITapGestureRecognizer) {
        if simon.suffix(1) == "P" {
            //break
        }
        else {
            simon = simon + "P"
        }
    }
    
    @objc func handleRotate(sender:UITapGestureRecognizer) {
        if simon.suffix(1) == "R" {
            //break
        }
        else {
            simon = simon + "R"
        }
    }
    
    @objc func handleSwipe(sender:UITapGestureRecognizer) {
        if simon.suffix(1) == "S" {
            //break
        }
        else {
            simon = simon + "S"
        }
    }
    
    @objc func handleLongTap(sender:UITapGestureRecognizer) {
        if simon.suffix(1) == "L" {
            //break
        }
        else {
            simon = simon + "L"
        }
    }
    
    @objc func check() {
        if (simon == checkStr) && (simon != "") && (checkStr != "") {
            speak (utterance: AVSpeechUtterance(string: "Cool, you did it!"))
            checkStr += randomizeSimon(RemoveChar: String(checkStr.suffix(1)))
            simon = ""
            score += 1
            scoreLabel.text = "Your score is " + String(score)
            let arr = checkStr.map { String($0) }
            for char in arr! {
                playGestures(c: char)
            }
        }
        else {
            simon = ""
            checkStr = ""
            speak (utterance: AVSpeechUtterance (string: "You failed."))
            scoreLabel.text = "Your final score was: " + String(score)
            speak (utterance: AVSpeechUtterance(string: "Your final score was: " + String(score)))
            button.setImage(icon2, for: .normal)
            speak (utterance: AVSpeechUtterance(string: "Do you want to try again?"))
            button.removeTarget(self, action: #selector(check), for: .touchUpInside)
            button.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        }
        
    }
    
    @objc func randomizeSimon(RemoveChar: String!) -> String{
        print (RemoveChar)
        let chars = ["T", "P", "R", "S", "L"]
        let editChars = chars.filter { $0 != RemoveChar }
        let randChar =
            editChars.randomElement()
        return (randChar!)
    }
    func playGestures(c: Character!){
        if c == "T" {
            speak(utterance: AVSpeechUtterance(string: "Tap"))
        }
        if c == "P" {
            speak(utterance: AVSpeechUtterance(string: "Pinch"))
        }
        if c == "R" {
            speak(utterance: AVSpeechUtterance(string: "Rotate"))
        }
        if c == "S" {
            speak(utterance: AVSpeechUtterance(string: "Swipe"))
        }
        if c == "L" {
            speak(utterance: AVSpeechUtterance(string: "Long Tap"))
        }
    }
}
PlaygroundPage.current.liveView = MyViewController()
