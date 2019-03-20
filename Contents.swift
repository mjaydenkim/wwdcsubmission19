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
    func playAudio(song: String) {
        do {
            if let fileURL = Bundle.main.path(forResource: song, ofType: "wav") {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
            } else {
                print("No file with specified name exists")
            }
        } catch let error {
            print("Can't play the audio file failed with an error \(error.localizedDescription)")
        }
        audioPlayer.play()
    }
    override func viewDidLoad() {
        self.view = UIView()
        self.view.backgroundColor = UIColor.white
        self.label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        self.label.center = CGPoint(x: 210, y: 210)
        self.label.textAlignment = .center
        self.scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        self.scoreLabel.center = CGPoint(x: 210, y: 400)
        self.scoreLabel.textAlignment = .center
        scoreLabel.text = String(score)
        self.view.addSubview(self.scoreLabel)
        self.button = UIButton(frame: CGRect(x: 210, y: 210, width: 200, height: 100))
        self.button.backgroundColor = .black
        self.button.center = CGPoint(x: 210, y: 100)
        self.button.setTitle("Tap me when you're done", for: .normal)
        self.button.addTarget(self, action: #selector(check), for: .touchUpInside)
        self.button.titleLabel?.font = .systemFont(ofSize: 12)
        self.view.addSubview(self.button)
        self.view.addSubview(self.label)
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
            playAudio(song: String(char))
            sleep (1)
        }
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
        if simon == checkStr {
            label.text = "Cool, you did it!"
            sleep(1)
            label.text = ""
            checkStr += randomizeSimon(RemoveChar: String(checkStr.suffix(1)))
            simon = ""
            score += 1
            scoreLabel.text = String(score)
            let arr = checkStr.map { String($0) }
            for char in arr! {
                playAudio(song: String(char))
                sleep (1)
            }
        }
        else {
            label.text = "You failed, man."
            scoreLabel.text = "Your final score was: " + String(score)
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
}
PlaygroundPage.current.liveView = MyViewController()




