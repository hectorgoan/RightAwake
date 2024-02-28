//
//  RightAwakeApp.swift
//  RightAwake
//
//  Created by Héctor Gonzalo Andrés on 27/2/24.
//

import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    @AppStorage("isAwake") private var isAwake : Bool = false
    
    var rightMouseDownMonitor: Any?
    var rightMouseUpMonitor: Any?
    var leftMouseDownMonitor: Any?
    var leftMouseUpMonitor: Any?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
                
        // Global Monitor right mouse down
        rightMouseDownMonitor = NSEvent.addGlobalMonitorForEvents(matching: .rightMouseDown) { event in
            self.switchAwakeStatus(to: true)
        }

        // Global Monitor right mouse up
        rightMouseUpMonitor = NSEvent.addGlobalMonitorForEvents(matching: .rightMouseUp) { event in
            self.switchAwakeStatus(to: true)
        }

        // Global Monitor left mouse down
        leftMouseDownMonitor = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { event in
            self.switchAwakeStatus(to: false)
        }

        // Global Monitor left mouse up
        leftMouseUpMonitor = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseUp) { event in
            self.switchAwakeStatus(to: false)
        }
    }
    
    func switchAwakeStatus(to desiredStatus: Bool) {
        if (isAwake != desiredStatus) {
            UserDefaults.standard.set(desiredStatus, forKey: "isAwake");
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        // Clean up monitors
        if let monitor = rightMouseDownMonitor {
            NSEvent.removeMonitor(monitor)
        }
        if let monitor = rightMouseUpMonitor {
            NSEvent.removeMonitor(monitor)
        }
        if let monitor = leftMouseDownMonitor {
            NSEvent.removeMonitor(monitor)
        }
        if let monitor = leftMouseUpMonitor {
            NSEvent.removeMonitor(monitor)
        }
    }
}

struct AppMenu: View {
    
    func activateDetection() {
        // Code for Activation
    }
    func deActivateDetection() {
        // Code for Deactivation
    }
    func quitApp() {
        NSApplication.shared.terminate(nil)
    }

    var body: some View {
        Button(action: activateDetection, label: { Text("Start detecting") })
        Button(action: deActivateDetection, label: { Text("Stop detecting") })
        
        Divider()

        Button(action: quitApp, label: { Text("Quit") })
    }
}


@main
struct RightAwakeApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("isAwake") private var isAwake = false
    
    init() {
        requestAccessibilityPermissions()
    }
    
    func requestAccessibilityPermissions() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString: true]
        AXIsProcessTrustedWithOptions(options)
    }
    
    var body: some Scene {
        MenuBarExtra("RightAwake", systemImage: isAwake ? "eye" : "eye.slash") {
            AppMenu()
        }
    }
}
