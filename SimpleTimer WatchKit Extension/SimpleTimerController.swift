//
//  SimpleTimerController.swift
//  SimpleTimer WatchKit Extension
//
//  Created by Paulo Alexandre Piornedo Panucci on 23/02/18.
//  Copyright © 2018 Paulo Alexandre Panucci. All rights reserved.
//

import WatchKit
import Foundation


class SimpleTimerController: WKInterfaceController {

    
    @IBOutlet var hourPicker: WKInterfacePicker!
    @IBOutlet var minutePicker: WKInterfacePicker!
    @IBOutlet var secondPicker: WKInterfacePicker!
    @IBOutlet var timer: WKInterfaceTimer!
    @IBOutlet var startButton: WKInterfaceButton!
    @IBOutlet var pauseButton: WKInterfaceButton!
    @IBOutlet var stopButton: WKInterfaceButton!
    
    let hours = [Int](0...100)
    let mins = [Int](0...59)
    let secs = [Int](0...59)
    
    var isPaused: Bool = false
    var controlTime: NSDate = NSDate()
    var startTime: NSDate = NSDate()
    var elapsedTime: TimeInterval = 0.0
    var pauseTime: NSDate = NSDate()
    var duration: TimeInterval = 0.0
    
    var hour = 0
    var min = 0
    var sec = 0
    
    var timerDate = NSDate()
    var hapticType: WKHapticType = .notification
    
//    @IBAction func pickerDidChange(_ value: Int) {
////        hapticType = WKHapticType(rawValue: value)!
////        WKInterfaceDevice.current().play(.click)
//    }
    
    
    @IBAction func hourPickerDidChange(_ value: Int) {
        hour = value
    }
    
    @IBAction func minPickerDidChange(_ value: Int) {
        min = value
    }
    
    @IBAction func secPickerDidChange(_ value: Int) {
        sec = value
    }
    
    func refreshPickerItems(){
        
        var hoursPickerItems: [WKPickerItem] = []
        for h in hours{
            let hoursPickerItem = WKPickerItem()
            hoursPickerItem.title = String(h)
            hoursPickerItems += [hoursPickerItem]
        }
        hourPicker.setItems(hoursPickerItems)
        
        var minsPickerItems: [WKPickerItem] = []
        for m in mins{
            let minsPickerItem = WKPickerItem()
            minsPickerItem.title = String(m)
            minsPickerItems += [minsPickerItem]
        }
        minutePicker.setItems(minsPickerItems)
        
        var secsPickerItems: [WKPickerItem] = []
        for s in secs{
            let secsPickerItem = WKPickerItem()
            secsPickerItem.title = String(s)
            secsPickerItems += [secsPickerItem]
        }
        secondPicker.setItems(secsPickerItems)
        
    }
    
    func strToTimeInterval(_ timeString: String) -> TimeInterval!{
        
        let timeMultipliers = [1.0, 60.0, 3600.0] // convert to seconds
        
        var time = 0.0
        var timeComponents = timeString.components(separatedBy: ":")
        timeComponents.reverse()
        
        if timeComponents.count > timeMultipliers.count {
            return nil
        } //time different hh:mm:ss
        
        for i in 0..<timeMultipliers.count{
            guard let timeComponent = Double(timeComponents[i]) else {
                return nil
            }
            time += timeComponent * timeMultipliers[i]
        }
        
        return time
    }
    
    @IBAction func startTimer() {
        //formating picker time in string hh:mm:ss
        let d = String(hour) + ":" + String(min) + ":" + String(sec)
        
        duration = strToTimeInterval(d)
        
        timer.setDate(NSDate(timeIntervalSinceNow: duration) as Date)
        
        //initialize start and control time
        startTime = NSDate()
        controlTime = NSDate()
        
        timer.start()
    }
    
    @IBAction func pauseTimer() {

        //if is not paused (if is counting)
        if(!isPaused) {
            //pause timer
            timer.stop()
            
            //record time that paused
            pauseTime = NSDate()
            
            isPaused = true
            
            // time running since paused
            elapsedTime = pauseTime.timeIntervalSince(startTime as Date)

            pauseButton.setTitle("Res")
        }
        else {
            //storing new duration info
            let newDuration = duration - elapsedTime
            
            // setting new time in timer
            timer.setDate(NSDate(timeIntervalSinceNow: duration - elapsedTime) as Date)
            
            //replacing duration for future pauses/play
            duration = newDuration
            
            isPaused = false
            startTime = NSDate()
            timer.start()
            pauseButton.setTitle("Pause")
        }
        
        
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        refreshPickerItems()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
