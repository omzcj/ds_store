//
//  main.swift
//  ds_store
//
//  Created by 张朝杰 on 2021/8/8.
//

import Foundation

var removeCount = 0
var searchCount = 0

let action = CommandLine.argc > 1 ? CommandLine.arguments[1] : nil

func _remove(path: String) -> Void {
    if FileManager.default.fileExists(atPath: path) {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch let error {
            print(path, "remove failed", error.localizedDescription)
        }
    }
}

if action == "monit" {
    let stream = FSEventStreamCreate(kCFAllocatorDefault, { (streamRef:ConstFSEventStreamRef, clientCallBackInfo:UnsafeMutableRawPointer?, numEvents:Int, eventPaths:UnsafeMutableRawPointer, eventFlags:UnsafePointer<FSEventStreamEventFlags>, eventIds:UnsafePointer<FSEventStreamEventId>) in
        
        let paths = Array(UnsafeBufferPointer(start: eventPaths.bindMemory(to: UnsafePointer<CChar>.self, capacity: numEvents), count: numEvents))
        for i in 0 ... numEvents - 1 {
            let path = String(cString: paths[i])
            if path.hasSuffix(".DS_Store") {
                _remove(path: path)
                removeCount += 1
                print(path, removeCount, "remove")
            }
//            if !path.hasSuffix(".DS_Store") {return}
//            let eventFlag = eventFlags[i]
//            if (UInt(kFSEventStreamEventFlagItemCreated) | UInt(kFSEventStreamEventFlagItemModified)) & UInt(eventFlag) != 0 {
//                print("created or modified", path)
//                _remove(path: path)
//            } else if UInt(kFSEventStreamEventFlagItemRemoved) & UInt(eventFlag) != 0 {
//                print("removed", path)
//            } else {
//                print(eventFlags, path)
//            }
//            print(path, count, "found")
//            count += 1
        }
    }, nil, ["/"] as CFArray, FSEventStreamEventId(kFSEventStreamEventIdSinceNow), 1.0, FSEventStreamCreateFlags(kFSEventStreamCreateFlagFileEvents))!
    FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
    FSEventStreamStart(stream)
    CFRunLoopRun()
} else if action == "list" {
    let rootPath = "/"
    let enumerator = FileManager.default.enumerator(atPath: rootPath)
    while let element = enumerator?.nextObject() as? String {
        let path = (rootPath as NSString).appendingPathComponent(element)
        if element.hasSuffix(".DS_Store") {
            print(path)
        }
    }
} else if action == "clean" {
    let rootPath = "/"
    let enumerator = FileManager.default.enumerator(atPath: rootPath)
    while let element = enumerator?.nextObject() as? String {
        let path = (rootPath as NSString).appendingPathComponent(element)
        if element.hasSuffix(".DS_Store") {
            _remove(path: path)
            removeCount += 1
            print(path, removeCount, "remove")
        }
        searchCount % 100000 != 0 ? () : print(path, searchCount, "search")
        searchCount += 1
    }
} else if action == "help" {
    print("ds_store monit")
    print("ds_store list")
    print("ds_store clean")
    print("ds_store help")
} else {
    print("ds_store help for more")
}
