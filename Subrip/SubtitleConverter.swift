//
//  SubtitleConverter.swift
//  Subrip
//
//  Created by Marcin Czachurski on 24.09.2015.
//  Copyright © 2015 SunLine Technologies. All rights reserved.
//

import Cocoa
import Foundation

public class SubtitleConverter
{
    private let filePath:NSURL!
    private let frameRate:Double!
    private var orginalFileContent:String!
    private var parsedSubtitleLines:[SubtitleLine] = [SubtitleLine]()
    private var startChar: Character = "["
    private var endChar: Character = "]"
    
    init(url:NSURL, rate:Double)
    {
        filePath = url
        frameRate = rate
    }
    
    public func convertToSrt() -> String?
    {
        if(!getOrginalFileContent())
        {
            return nil
        }
        
        if(!chooseTimeCharacters())
        {
            return nil
        }
        
        parseOrginalContent()
        let srtString = createSrtString()
        return srtString
    }
    
    private func chooseTimeCharacters() -> Bool
    {
        if(orginalFileContent[orginalFileContent.startIndex] == "[")
        {
            startChar = "["
            endChar = "]"
        }
        else if(orginalFileContent[orginalFileContent.startIndex] == "{")
        {
            startChar = "{"
            endChar = "}"
        }
        else
        {
            let alert = NSAlert()
            alert.messageText = "Warning"
            alert.addButtonWithTitle("Ok")
            alert.informativeText = "The type of file wasn't recognized."
            
            let window = NSApplication.sharedApplication().windows.first!
            alert.beginSheetModalForWindow(window, completionHandler: nil )
            return false
        }
        
        return true
    }
    
    private func getOrginalFileContent() -> Bool
    {
        do
        {
            orginalFileContent = try String(contentsOfFile: filePath.path!)
        }
        catch
        {
            let alert = NSAlert()
            alert.messageText = "Warning"
            alert.addButtonWithTitle("Ok")
            alert.informativeText = "Error during reading file."
            
            let window = NSApplication.sharedApplication().windows.first!
            alert.beginSheetModalForWindow(window, completionHandler: nil )
            return false
        }
        
        return true
    }
    
    private func parseOrginalContent()
    {
        let lines = orginalFileContent.componentsSeparatedByString("\n")
        for item in lines
        {
            var line = item
            let subtitleLine = SubtitleLine()
            
            if let startIndex = line.characters.indexOf(startChar) {
                if let endIndex = line.characters.indexOf(endChar) {
                    
                    let number = line.substringWithRange(Range<String.Index>(start: startIndex.advancedBy(1), end: endIndex))
                    line = line.substringFromIndex(endIndex.advancedBy(1))
                    subtitleLine.startFrame = Int(number)
                }
            }
            
            if let startIndex = line.characters.indexOf(startChar) {
                if let endIndex = line.characters.indexOf(endChar) {
                    
                    let number = line.substringWithRange(Range<String.Index>(start: startIndex.advancedBy(1), end: endIndex))
                    line = line.substringFromIndex(endIndex.advancedBy(1))
                    subtitleLine.endFrame = Int(number)
                }
            }
            
            subtitleLine.textLine = line
            parsedSubtitleLines.append(subtitleLine)
        }
    }
    
    private func createSrtString() -> String
    {
        var parsedText = ""
        var line = 0
        
        for item in parsedSubtitleLines
        {
            if(item.startFrame == nil || item.endFrame == nil || item.textLine == nil || item.textLine!.isEmpty)
            {
                continue
            }
            
            line++
            let startTime = getFormattedTime(item.startFrame!)
            let endTime = getFormattedTime(item.endFrame!)
            
            let lines = item.textLine!.componentsSeparatedByString("|")
            
            parsedText += "\(line)\n"
            parsedText += "\(startTime) --> \(endTime)\n"
            for line in lines
            {
                parsedText += "\(line)\n"
            }
            
            parsedText += "\n"
        }
        
        return parsedText
    }
    
    private func getFormattedTime(frame:Int) -> String
    {
        let startSeconds = Double(frame) / frameRate
        
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm:ss,SSS"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        
        let date = NSDate(timeIntervalSinceReferenceDate: startSeconds)
        return formatter.stringFromDate(date)
    }
}