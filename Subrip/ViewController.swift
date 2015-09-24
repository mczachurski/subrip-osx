//
//  ViewController.swift
//  Subrip
//
//  Created by Marcin Czachurski on 24.09.2015.
//  Copyright © 2015 SunLine Technologies. All rights reserved.
//

import Cocoa

class ViewController: NSViewController
{
    private var filePath:NSURL!

    @IBOutlet weak var fileNameOutlet: NSTextField!
    @IBOutlet weak var framesOutlet: NSTextField!
    @IBOutlet weak var convertOutlet: NSButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        framesOutlet.doubleValue = 23.976
    }

    func setURL(url:NSURL)
    {
        filePath = url
        fileNameOutlet.stringValue = filePath.lastPathComponent!
        framesOutlet.enabled = true
        convertOutlet.enabled = true
    }
    
    override var representedObject: AnyObject?
    {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func convertAction(sender: AnyObject)
    {
        let subtitleConverter = SubtitleConverter(url: filePath, rate: framesOutlet.doubleValue)
        let parsedText = subtitleConverter.convertToSrt()
        
        if(parsedText == nil)
        {
            return
        }
        
        let savePanel = NSSavePanel()        
        savePanel.beginWithCompletionHandler { (result) -> Void in
            if(result == NSFileHandlingPanelOKButton)
            {
                do
                {
                    try parsedText!.writeToURL(savePanel.URL!, atomically: true, encoding: NSUTF8StringEncoding)
                }
                catch
                {
                    let alert = NSAlert()
                    alert.messageText = "Warning"
                    alert.addButtonWithTitle("Ok")
                    alert.informativeText = "Error during saving the file."
                    
                    let window = NSApplication.sharedApplication().windows.first!
                    alert.beginSheetModalForWindow(window, completionHandler: nil )
                }
            }
        }
    }
}

