//
//  RightAwakeApp.swift
//  RightAwake
//
//  Created by Héctor Gonzalo Andrés on 27/2/24.
//

import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var rightMouseDownMonitor: Any?
    var rightMouseUpMonitor: Any?
    var leftMouseDownMonitor: Any?
    var leftMouseUpMonitor: Any?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
                
        
        // Monitor right mouse down
        rightMouseDownMonitor = NSEvent.addGlobalMonitorForEvents(matching: .rightMouseDown) { event in
            UserDefaults.standard.set(true, forKey: "isAwake");
        }

        // Monitor right mouse up
        rightMouseUpMonitor = NSEvent.addGlobalMonitorForEvents(matching: .rightMouseUp) { event in
            UserDefaults.standard.set(true, forKey: "isAwake");
        }

        // Monitor left mouse down
        leftMouseDownMonitor = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { event in
            UserDefaults.standard.set(false, forKey: "isAwake");
        }

        // Monitor left mouse up
        leftMouseUpMonitor = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseUp) { event in
            UserDefaults.standard.set(false, forKey: "isAwake");
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
        Button(action: activateDetection, label: { Text("Activate detection") })
        Button(action: deActivateDetection, label: { Text("Deactivate detection") })
        
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
