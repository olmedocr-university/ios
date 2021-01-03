//
//  OSLog.swift
//  votify
//
//  Created by Raul Olmedo on 08/04/2020.
//  Copyright © 2020 Raul Olmedo. All rights reserved.
//

import os.log
import Foundation

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let mainTableViewController = OSLog(subsystem: subsystem, category: "MainTableViewController")
    static let miniPlayerViewController = OSLog(subsystem: subsystem, category: "MiniPlayerViewController")
    static let musicPlayer = OSLog(subsystem: subsystem, category: "MusicPlayer")
    static let tabBarViewController = OSLog(subsystem: subsystem, category: "TabBarViewController")

}
