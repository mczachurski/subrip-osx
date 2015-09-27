//
//  AppDelegate.swift
//  Subrip
//
//  Created by Marcin Czachurski on 24.09.2015.
//  Copyright © 2015 SunLine Technologies. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{    
    func applicationDidFinishLaunching(aNotification: NSNotification)
    {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification)
    {
        // Insert code here to tear down your application
    }
    
    func application(sender: NSApplication, openFile filename: String) -> Bool
    {
        let document = NSURL(fileURLWithPath: filename)
        chooseFileInMainView(document)
        return true
    }

    @IBAction func openFileAction(sender: AnyObject)
    {
        let panel = NSOpenPanel()
        
        panel.title = "Choose a .TXT subtitle file";
        panel.showsHiddenFiles = false
        panel.canChooseDirectories = false
        panel.canCreateDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["txt"]
        
        panel.beginWithCompletionHandler { (result) -> Void in
            if(result == NSFileHandlingPanelOKButton)
            {
                let document = panel.URL!
                self.chooseFileInMainView(document)
            }
        }
    }
    
    private func chooseFileInMainView(document:NSURL)
    {
        let controller = NSApplication.sharedApplication().windows.first!.contentViewController as! ViewController
        controller.setURL(document)
        NSDocumentController.sharedDocumentController().noteNewRecentDocumentURL(document)
    }
}

