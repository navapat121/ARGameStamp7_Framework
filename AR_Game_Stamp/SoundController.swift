/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import AVFoundation

class SoundController {
    let frameworkBundle = Bundle(identifier: "org.cocoapods.ARGameStamp7-11")
    static let shared = SoundController()
    var sound_on = true
    var backgroundMusicPlayer: AVAudioPlayer?
    
    var pingpong: AVAudioPlayer?
    
    var bombEffect: AVAudioPlayer?
    // Global
    var clickButton: AVAudioPlayer?
    
    // Gameplay
    var bgmGameplayAR : AVAudioPlayer?
    var bgmSpecialStampGameplayAR : AVAudioPlayer?
    var recieveStampToBasket : AVAudioPlayer?
    //var touchSFX : AVAudioPlayer?
    var stampMoveToBasket : AVAudioPlayer?
    
    var popEffect: AVAudioPlayer?
    var popEffect2: AVAudioPlayer?
    var popEffect3: AVAudioPlayer?
    var popEffect4: AVAudioPlayer?
    var popEffect5: AVAudioPlayer?
    var popEffect6: AVAudioPlayer?
    var popEffect7: AVAudioPlayer?
    var popEffect8: AVAudioPlayer?
    var popEffect9: AVAudioPlayer?
    
    // Gameplay - StampItems
    var tapHelpStamp : AVAudioPlayer?
    var timeTick1 : AVAudioPlayer?
    var timeTick2 : AVAudioPlayer?
    var timeTick3 : AVAudioPlayer?
    var timeTick4 : AVAudioPlayer?
    
    // StampItems - HourGlass
    var increaseTime : AVAudioPlayer?
    var hourGlassAnimated : AVAudioPlayer?
    var tapHourGlassStamp : AVAudioPlayer?
    // StampItems - Net
    var tapNetStamp : AVAudioPlayer?
    var powerUp: AVAudioPlayer?
    // StampItems - Bomb
    var reduceTime: AVAudioPlayer?
    var tapBombStamp: AVAudioPlayer?
    
    // Gameplay - RewardSound
    var lightSpecialStampToCoupon: AVAudioPlayer?
    var specialStampPopup: AVAudioPlayer?
    var receivePopUpSFX: AVAudioPlayer?
    var rewardPopUpSFX: AVAudioPlayer?
    
    // Gameplay - Alert
    var timeUpSFX : AVAudioPlayer?
    var alertSpecialStamp : AVAudioPlayer?
    
    // Gameplay - Start_Game
    var countDownSFX : AVAudioPlayer?
    var startSFX: AVAudioPlayer?
    
    private init() {
        // Global
        clickButton = preloadSoundEffect("clickSFX.mp3")
        
       // Gameplay
        bgmGameplayAR = preloadSoundEffect("BGM Gameplay AR.mp3")
        bgmSpecialStampGameplayAR = preloadSoundEffect("BGM Special Stamp Scene.mp3")
        recieveStampToBasket = preloadSoundEffect("recieveStampToBasket.mp3")
        stampMoveToBasket = preloadSoundEffect("stampMoveToBasket.mp3")
        
        // Tap Stamp Sound
        popEffect = preloadSoundEffect("TouchSFX.mp3")
        popEffect2 = preloadSoundEffect("TouchSFX.mp3")
        popEffect3 = preloadSoundEffect("TouchSFX.mp3")
        popEffect4 = preloadSoundEffect("TouchSFX.mp3")
        popEffect5 = preloadSoundEffect("TouchSFX.mp3")
        popEffect6 = preloadSoundEffect("TouchSFX.mp3")
        popEffect7 = preloadSoundEffect("TouchSFX.mp3")
        popEffect8 = preloadSoundEffect("TouchSFX.mp3")
        popEffect9 = preloadSoundEffect("TouchSFX.mp3")
        
        // Gameplay - StampItems
        tapHelpStamp = preloadSoundEffect("tapHelpStamp.mp3")
        timeTick1 = preloadSoundEffect("timeTick.mp3")
        timeTick2 = preloadSoundEffect("timeTick.mp3")
        timeTick3 = preloadSoundEffect("timeTick.mp3")
        timeTick4 = preloadSoundEffect("timeTick.mp3")

        // StampItems - HourGlass
        increaseTime = preloadSoundEffect("Increase Time.mp3")
        hourGlassAnimated = preloadSoundEffect("hourGlassAnimated.mp3")
        tapHourGlassStamp = preloadSoundEffect("tapHourGlassStamp.mp3")
        // StampItems - Net
        tapNetStamp = preloadSoundEffect("tapNetStamp.mp3")
        powerUp = preloadSoundEffect("Power UP Sound.mp3")
        // StampItems - Bomb
        reduceTime = preloadSoundEffect("Reduce Time.mp3")
        tapBombStamp = preloadSoundEffect("tapBombStamp.mp3")

        // Gameplay - RewardSound
        lightSpecialStampToCoupon = preloadSoundEffect("Light Special Stamp To Coupon.mp3")
        specialStampPopup = preloadSoundEffect("Special Stamp Popup.mp3")
        receivePopUpSFX = preloadSoundEffect("Recieve Popup SFX.mp3")
        rewardPopUpSFX = preloadSoundEffect("Reward Popup SFX.mp3")

         // Gameplay - Alert
        timeUpSFX = preloadSoundEffect("TimeUp SFX.mp3")
        alertSpecialStamp = preloadSoundEffect("Aleart Special Stamp.mp3")

        // Gameplay - Start_Game
        countDownSFX = preloadSoundEffect("Countdown SFX.mp3")
        startSFX = preloadSoundEffect("Start SFX.mp3")
    }
    
    func playClickButton(){
        if(clickButton?.isPlaying == false){
            clickButton?.play()
        }
    }
    
    // ====================
    // Gameplay
    // ====================
    func playBGMGameplay() {
        if !sound_on {return}
        bgmGameplayAR?.currentTime = 0;
        bgmGameplayAR?.numberOfLoops = .max;
        bgmGameplayAR?.play()
    }
    
    func stopBGMGameplay() {
        if !sound_on {return}
        if(bgmGameplayAR?.isPlaying == true){
            bgmGameplayAR?.stop()
        }
    }
    
    func playBGMSpeicalGameplay(){
        if !sound_on {return}
        bgmSpecialStampGameplayAR?.numberOfLoops = .max
        bgmSpecialStampGameplayAR?.play()
    }
    
    func stopBGMSpeicalGameplay() {
        if !sound_on {return}
        if(bgmSpecialStampGameplayAR?.isPlaying == true){
            bgmSpecialStampGameplayAR?.stop()
        }
    }
    
    func playRecieveStampToBasket(){
        if !sound_on {return}
        if(recieveStampToBasket?.isPlaying == false){
            recieveStampToBasket?.play()
        }
    }
    
    func playStampMoveToBasket(){
        if !sound_on {return}
        if(stampMoveToBasket?.isPlaying == false){
            stampMoveToBasket?.play()
        }
    }
    
    func playPopEffect() {
        if !sound_on {return}
        if(popEffect?.isPlaying == false){
            popEffect?.play()
        } else if(popEffect2?.isPlaying == false){
            popEffect2?.play()
        } else if(popEffect3?.isPlaying == false){
            popEffect3?.play()
        } else if(popEffect4?.isPlaying == false){
            popEffect4?.play()
        } else if(popEffect5?.isPlaying == false){
            popEffect5?.play()
        }else if(popEffect6?.isPlaying == false){
            popEffect6?.play()
        }else if(popEffect7?.isPlaying == false){
            popEffect7?.play()
        }else if(popEffect8?.isPlaying == false){
            popEffect8?.play()
        }else if(popEffect9?.isPlaying == false){
            popEffect9?.play()
        }
    }
    // ======================
    // Gameplay - StampItems
    // ======================
    func playTapHelpStamp(){
        if !sound_on {return}
        if(tapHelpStamp?.isPlaying == false){
            tapHelpStamp?.play()
        }
    }
    
    func playTimeTick(){
        if !sound_on {return}
        if(timeTick1?.isPlaying == false){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.timeTick1?.play()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                self.timeTick2?.play()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                self.timeTick3?.play()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                self.timeTick4?.play()
            })
        }
    }
    // ======================
    // StampItems - HourGlass
    // ======================
    func playIncreaseTime() {
        if !sound_on {return}
        if(increaseTime?.isPlaying == false){
            increaseTime?.play()
        }
    }
    
    func playHourGlassAnimated() {
        if(hourGlassAnimated?.isPlaying == false){
            hourGlassAnimated?.play()
        }
    }
    
    func playTapHourGlassStamp() {
        if !sound_on {return}
        if(tapHourGlassStamp?.isPlaying == false){
            tapHourGlassStamp?.play()
        }
    }
    // ======================
    // StampItems - Net
    // ======================
    func playTapNetStamp() {
        if !sound_on {return}
        if(tapNetStamp?.isPlaying == false){
            tapNetStamp?.play()
        }
    }
    
    func playPowerUp() {
        if !sound_on {return}
        powerUp?.numberOfLoops = -1
        powerUp?.play()
    }
    
    func stopPowerUp(){
        if !sound_on {return}
        if(powerUp?.isPlaying == true){
            powerUp?.stop()
        }
    }
    // ======================
    // StampItems - Bomb
    // ======================
    func playReduceTime() {
        if !sound_on {return}
       if(reduceTime?.isPlaying == false){
           reduceTime?.play()
       }
   }
    
    func playTapBombStamp() {
        if !sound_on {return}
        if(tapBombStamp?.isPlaying == false){
            tapBombStamp?.play()
        }
    }

    // ======================
    // Gameplay - RewardSound
    // ======================
    func playLightSpecialStampToCoupon() {
        if !sound_on {return}
        if(lightSpecialStampToCoupon?.isPlaying == false){
            lightSpecialStampToCoupon?.play()
        }
    }
    
    func playSpecialStampPopup() {
        if !sound_on {return}
        if(specialStampPopup?.isPlaying == false){
            specialStampPopup?.play()
        }
    }
    
    func playReceivePopUpSFX() {
        if !sound_on {return}
        if(receivePopUpSFX?.isPlaying == false){
            receivePopUpSFX?.play()
        }
    }
    
    func playRewardPopUpSFX() {
        if !sound_on {return}
        if(rewardPopUpSFX?.isPlaying == false){
            rewardPopUpSFX?.play()
        }
    }

    // ======================
    // Gameplay - Alert
    // ======================
    func playTimeUpSFX() {
        if !sound_on {return}
        if(timeUpSFX?.isPlaying == false){
            timeUpSFX?.play()
        }
    }
    
    func playAlertSpecialStamp() {
        if !sound_on {return}
        if(alertSpecialStamp?.isPlaying == false){
            alertSpecialStamp?.play()
        }
    }

    // ======================
    // Gameplay - Start_Game
    // ======================
    func playCountDownSFX() {
        if !sound_on {return}
        if(countDownSFX?.isPlaying == false){
            countDownSFX?.play()
        }
    }
    
    func playStartSFX() {
        if !sound_on {return}
        if(startSFX?.isPlaying == false){
            startSFX?.play()
        }
    }
    
    func stopBackgroundSound() {
        powerUp?.stop()
        bgmSpecialStampGameplayAR?.stop()
        bgmGameplayAR?.stop()
    }
    
    
    func preloadSoundEffect(_ filename: String) -> AVAudioPlayer? {
        if let url = frameworkBundle?.url(forResource: filename,
                                          withExtension: nil) {
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                return player
            } catch {
                print("file \(filename) not found")
            }
        }
        return nil
    }
}

