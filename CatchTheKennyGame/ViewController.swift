//
//  ViewController.swift
//  CatchTheKennyGame
//
//  Created by Zeynep Bayrak Demirel on 5.10.2022.
//

import UIKit

class ViewController: UIViewController {

    var score = 0
    var timer = Timer()
    var counter = 0
    var kennyArray = [UIImageView]()
    var hideTimer = Timer() //random işini otomatik yapmak için bunu oluşturduk.
    var highScore = 0
    
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scorelabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var kenny1: UIImageView!
    @IBOutlet weak var kenny2: UIImageView!
    @IBOutlet weak var kenny3: UIImageView!
    @IBOutlet weak var kenny4: UIImageView!
    @IBOutlet weak var kenny5: UIImageView!
    @IBOutlet weak var kenny6: UIImageView!
    @IBOutlet weak var kenny7: UIImageView!
    @IBOutlet weak var kenny8: UIImageView!
    @IBOutlet weak var kenny9: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        scorelabel.text = "Score: \(score)"
        
        //highscore u user defaultsa kaydetmiştik countdown fonksiyonu içinde, burda onu ordan çekicez
        let storedHighScore = UserDefaults.standard.object(forKey: "highScore")
        
        if storedHighScore == nil {
            highScore = 0
            highScoreLabel.text = "Highscore:\(highScore)"
        }
        
        if let newScore = storedHighScore as? Int {
            
            highScore = newScore
            highScoreLabel.text = "Highscore:\(highScore)"
        }
        
        
        //Kullanıcıların kennylerin üzerine tıklamasını etkin hale getirmeliyiz.
        
        kenny1.isUserInteractionEnabled = true
        kenny2.isUserInteractionEnabled = true
        kenny3.isUserInteractionEnabled = true
        kenny4.isUserInteractionEnabled = true
        kenny5.isUserInteractionEnabled = true
        kenny6.isUserInteractionEnabled = true
        kenny7.isUserInteractionEnabled = true
        kenny8.isUserInteractionEnabled = true
        kenny9.isUserInteractionEnabled = true
        
        // Bir recognizer yapıp hepsine tanımlayamıyoruz, hepsine tek tek tanımlayacağız.
        let recognizer1 = UITapGestureRecognizer(target: self, action: #selector (increaseScore))
        let recognizer2 = UITapGestureRecognizer(target: self, action: #selector (increaseScore))
        let recognizer3 = UITapGestureRecognizer(target: self, action: #selector (increaseScore))
        let recognizer4 = UITapGestureRecognizer(target: self, action: #selector (increaseScore))
        let recognizer5 = UITapGestureRecognizer(target: self, action: #selector (increaseScore))
        let recognizer6 = UITapGestureRecognizer(target: self, action: #selector (increaseScore))
        let recognizer7 = UITapGestureRecognizer(target: self, action: #selector (increaseScore))
        let recognizer8 = UITapGestureRecognizer(target: self, action: #selector (increaseScore))
        let recognizer9 = UITapGestureRecognizer(target: self, action: #selector (increaseScore))
        
        
        //kennyleri recognizerlara atıyoruz.
        kenny1.addGestureRecognizer(recognizer1)
        kenny2.addGestureRecognizer(recognizer2)
        kenny3.addGestureRecognizer(recognizer3)
        kenny4.addGestureRecognizer(recognizer4)
        kenny5.addGestureRecognizer(recognizer5)
        kenny6.addGestureRecognizer(recognizer6)
        kenny7.addGestureRecognizer(recognizer7)
        kenny8.addGestureRecognizer(recognizer8)
        kenny9.addGestureRecognizer(recognizer9)
        
        kennyArray = [kenny1, kenny2, kenny3, kenny4, kenny5,kenny6, kenny7, kenny8, kenny9]
        
        // Timers
        
        counter = 10
        timeLabel.text = String(counter)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector (countDown), userInfo: nil, repeats: true)
        hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(hideKenny), userInfo: nil, repeats: true) //hideKenyyi timer ın içine yazdık, otomatik timer boyunca değişecek
        hideKenny()
    }
    
    @objc func hideKenny (){
     
        for kenny in kennyArray {
            kenny.isHidden = true
        }
        
       let random = Int( arc4random_uniform(UInt32(kennyArray.count-1))) // Random ı index olarak kullanacagımız için -1 dedik. UInt32(10) demek bana 0 ile 10 arasında bir random sayı bul demek. Bu ifade int döndürmez o nedenle Int diyoruz 
        kennyArray[random].isHidden = false
    }
    
    

    @objc func increaseScore (){
        score += 1
        scorelabel.text = "Score: \(score)" //bunu tekrar yazıyorum buraya score güncellensin diye
        
    }
    
    @objc func countDown (){
        counter-=1
        timeLabel.text = String (counter)
        
        if counter == 0 {
            timer.invalidate() //counterı durdurmak için
            hideTimer.invalidate()
            
            for kenny in kennyArray { //timer bitince bütün kennyleri tekrar görünmez yapmak için
                kenny.isHidden = true
            }
            
            // Highscore u burda countdown bitince yapıcaz. Kullanıcıya mesaj göstermeden halledebilriz.
            if self.score > self.highScore {
                
                self.highScore = self.score
                highScoreLabel.text = "Highscore: \(self.highScore)"
                UserDefaults.standard.set(self.highScore, forKey: "highScore")// kaydettik highscore u. viewdidload ta highscore u kontrol etmemiz lazım
            }
            
            let alert = UIAlertController(title: "time's up!", message: "do you want to play again", preferredStyle: UIAlertController.Style.alert)
            
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil) //basılınca bir şey olmasına gerek yok handler boş ondan
            let replayButton = UIAlertAction (title: "Replay", style: UIAlertAction.Style.default) { UIAlertAction in
                
                // score ve counter ı resetliyoruz Replay tuşu için.
                self.score = 0
                self.scorelabel.text = "Score: \(self.score)"
                self.counter = 10
                self.timeLabel.text = String (self.counter)
                
                //timerları yine çalıştırmamız lazım.
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector (self.countDown), userInfo: nil, repeats: true)
                self.hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.hideKenny), userInfo: nil, repeats: true)
            }
            
            alert.addAction(okButton)
            alert.addAction(replayButton)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    
    
}

