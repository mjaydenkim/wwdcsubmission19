import UIKit
import PlaygroundSupport
import AVFoundation

PlaygroundPage.current.needsIndefiniteExecution = true

class MyViewController : UIViewController {
    var titleLabel = UILabel(frame: .init(x: 0, y: 0, width: 200, height: 200))
    var label = UILabel(frame: .init(x: 0, y: 0, width: 200, height: 200))
    var scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var score: Int! = 0
    var simon: String! = ""
    var checkStr: String! = ""
    var button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var audioPlayer = AVAudioPlayer()
    var audioPlayer2 = AVAudioPlayer()
    let icon = UIImage(named: "check3.png")! //from ionicons
    let icon2 = UIImage(named: "restart.png")! //also from ionicons
    let icon3 = UIImage(named: "letsgo.png") //also from ionicons
    let synth = AVSpeechSynthesizer()
    
    @objc func playMusic(song: String, numLoops: Int) {
        do {
            if let fileURL = Bundle.main.path(forResource: song, ofType: "wav") {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
            } else {
                print("No file with specified name exists")
            }
        } catch let error {
            print("Can't play the audio file failed with an error \(error.localizedDescription)")
        }
        audioPlayer.numberOfLoops = numLoops
        audioPlayer.volume = 0.5
        audioPlayer.play()
    }
    @objc func playBGM() {
        playMusic(song: "bgm", numLoops: -1)
    }
    func setScore(_value: Int) {
        UserDefaults.standard.set(score, forKey: "Key")
    }
    func getScore() -> Int {
        return UserDefaults.standard.integer(forKey: "Key")
    }
    func speak(string: String!){
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synth.speak(utterance)
    }
    @objc func restartGame() {
        titleLabel.textColor = UIColor(red:206/255, green: 206/255, blue: 206/255, alpha: 1.0)
        if synth.isSpeaking {
            synth.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        button.removeTarget(self, action: #selector(restartGame), for: .touchUpInside)
        simon = ""
        checkStr = ""
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        label.text = "The announcer will read two gestures, and you will have to execute them after the voice ends. More gestures will be added as the game progresses."
        label.numberOfLines = 0
        score = 0
        button.setImage(icon3, for: .normal)
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
    }
    @objc func startGame(completion: (_ success: Bool) -> Void) {
        button.removeTarget(self, action: #selector(startGame), for: .touchUpInside)
        button.addTarget(self, action: #selector(check), for: .touchUpInside)
        button.setImage(icon, for: .normal)
        view.addSubview(self.button)
        view.addSubview(self.scoreLabel)
        speak(string: "3...")
        usleep(100)
        speak(string: "2...")
        usleep(100)
        speak(string: "1...")
        usleep(100)
        speak(string: "Let's Go!")
        usleep(500)
        let v1: String! = randomizeSimon(RemoveChar: "")
        checkStr = checkStr + v1 + randomizeSimon(RemoveChar: v1)
        let arr = checkStr.map { String($0) }
        for char in arr! {
            playGestures(c: char)
        }
        label.text = "Good Luck!"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.bold)
        perform(#selector(playBGM), with: nil, afterDelay: 2.3)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 54/255.0, green: 54/255.0, blue: 52/255.0, alpha: 1.0)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        label.textAlignment = .center
        label.text = "The announcer will read two gestures, and you will have to execute them on your screen after the voice ends. More gestures will be added as the game progresses."
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        label.textColor = UIColor(red:183/255, green: 159/255, blue: 206/255, alpha: 1.0)
        view.addSubview(self.label)
        titleLabel.textAlignment = .center
        titleLabel.text = "ReGest"
        titleLabel.font = UIFont.systemFont(ofSize: 57, weight: UIFont.Weight.bold)
        titleLabel.textColor = UIColor(red:206/255, green: 206/255, blue: 206/255, alpha: 1.0)
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        scoreLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = UIColor(red: 128/250, green: 197/250, blue: 236/250, alpha: 1.0)
        scoreLabel.text = "Your score is " + String(score)
        button.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        button.backgroundColor = UIColor(red: 40/255.0, green: 130/255.0, blue: 178/255.0, alpha: 1.0)
        button.layer.cornerRadius = self.button.frame.height/8
        button.layer.shadowOpacity = 0.25
        button.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 0, height: 7)
        button.setImage(icon3, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        view.addSubview(button)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.center = view.center
        scoreLabel.center.x = view.center.x
        scoreLabel.center.y = view.center.y * 1.5
        button.center.x = view.center.x
        button.center.y = view.center.y * 1.8
        titleLabel.center.x = view.center.x
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
        titleLabel.textColor = UIColor(red: 104/250, green: 155/250, blue: 121/250, alpha: 1)
        UIView.animate(withDuration: 1.0, animations: {
            self.titleLabel.textColor = UIColor(red:206/255, green: 206/255, blue: 206/255, alpha: 1.0)
        })
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    @objc func handleTap(sender:UITapGestureRecognizer) {
        if simon.suffix(1) == "T" {
            //break
        }
        simon = simon + "T"
        label.text = ""
    }
    @objc func handlePinch(sender:UITapGestureRecognizer) {
        if simon.suffix(1) == "P" {
            //break
        }
        else {
            simon = simon + "P"
            label.text = ""
        }
    }
    
    @objc func handleRotate(sender:UITapGestureRecognizer) {
        if simon.suffix(1) == "R" {
            //break
        }
        else {
            simon = simon + "R"
            label.text = ""
        }
    }
    
    @objc func handleSwipe(sender:UITapGestureRecognizer) {
        if simon.suffix(1) == "S" {
            //break
        }
        else {
            simon = simon + "S"
            label.text = ""
        }
    }
    
    @objc func handleLongTap(sender:UITapGestureRecognizer) {
        if simon.suffix(1) == "L" {
            //break
        }
        else {
            simon = simon + "L"
            label.text = ""
        }
    }
    @objc func changeColor(red: CGFloat, blue: CGFloat, green: CGFloat) {
        UIView.transition(with: self.titleLabel, duration: 1, options: .transitionCrossDissolve, animations: {
            self.titleLabel.textColor = UIColor(red: red/250, green: blue/250, blue: green/250, alpha: 1)
        }, completion: { _ in
            sleep(1)
            self.titleLabel.textColor = UIColor(red:206/255, green: 206/255, blue: 206/255, alpha: 1.0)
        })
    }
    @objc func check() {
        if (simon == checkStr) && (simon != "") && (checkStr != "") {
            changeColor(red: 104, blue: 155, green: 121)
            do {
                if let fileURL = Bundle.main.path(forResource: "success", ofType: "wav") {
                    audioPlayer2 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
                } else {
                    print("No file with specified name exists")
                }
            } catch let error {
                print("Can't play the audio file failed with an error \(error.localizedDescription)")
            }
            audioPlayer2.numberOfLoops = 0
            audioPlayer2.volume = 0.5
            audioPlayer2.play()
            titleLabel.textColor = UIColor(red: 104/250, green: 155/250, blue: 121/250, alpha: 1)
            speak (string: "Cool, you did it!")
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
            changeColor(red: 231, blue: 90, green: 83)
            print (simon)
            audioPlayer.stop()
            label.numberOfLines = 0
            scoreLabel.numberOfLines = 0
            playMusic(song: "fail", numLoops: 0)
            simon = ""
            checkStr = ""
            scoreLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
            speak (string: "Game Over.")
            label.text = "Your final score was: " + String(score)
            scoreLabel.text = ""
            speak (string: "Your final score was " + String(score))
            button.setImage(icon2, for: .normal)
            if score > getScore() {
                setScore(_value: score)
                speak(string: "You set a new highscore!")
            }
            speak (string: "Your highscore is" + String(getScore()))
            speak (string: "Do you want to try again?")
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
            speak(string: "Tap")
        }
        if c == "P" {
            speak(string: "Pinch")
        }
        if c == "R" {
            speak(string: "Rotate")
        }
        if c == "S" {
            speak(string: "Swipe")
        }
        if c == "L" {
            speak(string: "Long Tap")
        }
    }
}
PlaygroundPage.current.liveView = MyViewController()

