//
//  Preferences.swift
//  Aerial
//
//  Created by John Coates on 9/21/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation
import ScreenSaver

class Preferences {
    
    // MARK: - Types
    
    fileprivate enum Identifiers: String {
        case differentAerialsOnEachDisplay = "differentAerialsOnEachDisplay"
        case cacheAerials = "cacheAerials"
        case customCacheDirectory = "cacheDirectory"
        case manifestTvOS10 = "manifestTvOS10"
        case manifestTvOS11 = "manifestTvOS11"
        case manifestTvOS12 = "manifestTvOS12"
        case videoFormat = "videoFormat"
        case showDescriptions = "showDescriptions"
        case showDescriptionsMode = "showDescriptionsMode"
        case neverStreamVideos = "neverStreamVideos"
        case neverStreamPreviews = "neverStreamPreviews"
        case localizeDescriptions = "localizeDescriptions"
        case timeMode = "timeMode"
        case manualSunrise = "manualSunrise"
        case manualSunset = "manualSunset"
    }

    enum TimeMode : Int {
        case disabled, nightShift, manual, lightDarkMode
    }
    
    enum VideoFormat : Int {
        case v1080pH264, v1080pHEVC, v4KHEVC
    }
    
    enum DescriptionMode : Int {
        case fade10seconds, always
    }
    
    static let sharedInstance = Preferences()
    
    lazy var userDefaults: UserDefaults = {
        let module = "com.JohnCoates.Aerial"
        
        guard let userDefaults = ScreenSaverDefaults(forModuleWithName: module) else {
            print("Couldn't create ScreenSaverDefaults, creating generic UserDefaults")
            return UserDefaults()
        }
        
        return userDefaults
    }()
    
    // MARK: - Setup
    
    init() {
        registerDefaultValues()
    }
    
    func registerDefaultValues() {
        var defaultValues = [Identifiers: Any]()
        defaultValues[.differentAerialsOnEachDisplay] = false
        defaultValues[.cacheAerials] = true
        defaultValues[.videoFormat] = VideoFormat.v1080pH264
        defaultValues[.showDescriptions] = true
        defaultValues[.showDescriptionsMode] = DescriptionMode.fade10seconds
        defaultValues[.neverStreamVideos] = false
        defaultValues[.neverStreamPreviews] = false
        defaultValues[.localizeDescriptions] = false
        defaultValues[.timeMode] = TimeMode.disabled
        defaultValues[.manualSunrise] = "09:00"
        defaultValues[.manualSunset] = "19:00"
        
        let defaults = defaultValues.reduce([String: Any]()) {
            (result, pair:(key: Identifiers, value: Any)) -> [String: Any] in
            var mutable = result
            mutable[pair.key.rawValue] = pair.value
            return mutable
        }
        
        userDefaults.register(defaults: defaults)
    }
    
    // MARK: - Variables
    
    var differentAerialsOnEachDisplay: Bool {
        get {
            return value(forIdentifier: .differentAerialsOnEachDisplay)
        }
        set {
            setValue(forIdentifier: .differentAerialsOnEachDisplay,
                         value: newValue)
        }
    }
    
    var cacheAerials: Bool {
        get {
            return value(forIdentifier: .cacheAerials)
        }
        set {
            setValue(forIdentifier: .cacheAerials, value: newValue)
        }
    }
    
    var neverStreamVideos: Bool {
        get {
            return value(forIdentifier: .neverStreamVideos)
        }
        set {
            setValue(forIdentifier: .neverStreamVideos, value: newValue)
        }
    }
    
    var neverStreamPreviews: Bool {
        get {
            return value(forIdentifier: .neverStreamPreviews)
        }
        set {
            setValue(forIdentifier: .neverStreamPreviews, value: newValue)
        }
    }

    var localizeDescriptions: Bool {
        get {
            return value(forIdentifier: .localizeDescriptions)
        }
        set {
            setValue(forIdentifier: .localizeDescriptions, value: newValue)
        }
    }
    
    var manualSunrise: String? {
        get {
            return optionalValue(forIdentifier: .manualSunrise)
        }
        set {
            setValue(forIdentifier: .manualSunrise, value: newValue)
        }
    }
    
    var manualSunset: String? {
        get {
            return optionalValue(forIdentifier: .manualSunset)
        }
        set {
            setValue(forIdentifier: .manualSunset, value: newValue)
        }
    }
    
    var customCacheDirectory: String? {
        get {
            return optionalValue(forIdentifier: .customCacheDirectory)
        }
        set {
            setValue(forIdentifier: .customCacheDirectory, value: newValue)
        }
    }

    var manifestTvOS10: Data? {
        get {
            return optionalValue(forIdentifier: .manifestTvOS10)
        }
        set {
            setValue(forIdentifier: .manifestTvOS10, value: newValue)
        }
    }
    
    var manifestTvOS11: Data? {
        get {
            return optionalValue(forIdentifier: .manifestTvOS11)
        }
        set {
            setValue(forIdentifier: .manifestTvOS11, value: newValue)
        }
    }
    
    var manifestTvOS12: Data? {
        get {
            return optionalValue(forIdentifier: .manifestTvOS12)
        }
        set {
            setValue(forIdentifier: .manifestTvOS12, value: newValue)
        }
    }

    var timeMode: Int? {
        get {
            return optionalValue(forIdentifier: .timeMode)
        }
        set {
            setValue(forIdentifier: .timeMode, value: newValue)
        }
    }

    var videoFormat: Int? {
        get {
            return optionalValue(forIdentifier: .videoFormat)
        }
        set {
            setValue(forIdentifier: .videoFormat, value: newValue)
        }
    }

    var showDescriptionsMode: Int? {
        get {
            return optionalValue(forIdentifier: .showDescriptionsMode)
        }
        set {
            setValue(forIdentifier: .showDescriptionsMode, value: newValue)
        }
    }
    
    var showDescriptions: Bool {
        get {
            return value(forIdentifier: .showDescriptions)
        }
        set {
            setValue(forIdentifier: .showDescriptions,
                     value: newValue)
        }
    }
    
    func videoIsInRotation(videoID: String) -> Bool {
        let key = "remove\(videoID)"
        let removed = userDefaults.bool(forKey: key)
        return !removed
    }
    
    func setVideo(videoID: String, inRotation: Bool,
                  synchronize: Bool = true) {
        let key = "remove\(videoID)"
        let removed = !inRotation
        userDefaults.set(removed, forKey: key)
        
        if synchronize {
            self.synchronize()
        }
    }
    
    // MARK: - Setting, Getting
    
    fileprivate func value(forIdentifier identifier: Identifiers) -> Bool {
        let key = identifier.rawValue
        return userDefaults.bool(forKey: key)
    }
    
    fileprivate func optionalValue(forIdentifier identifier: Identifiers) -> String? {
        let key = identifier.rawValue
        return userDefaults.string(forKey: key)
    }

    fileprivate func optionalValue(forIdentifier identifier: Identifiers) -> Int? {
        let key = identifier.rawValue
        return userDefaults.integer(forKey: key)
    }

    fileprivate func optionalValue(forIdentifier
        identifier: Identifiers) -> Data? {
        let key = identifier.rawValue
        return userDefaults.data(forKey: key)
    }
    
    fileprivate func setValue(forIdentifier identifier: Identifiers, value: Any?) {
        let key = identifier.rawValue
        if value == nil {
            userDefaults.removeObject(forKey: key)
        } else {
            userDefaults.set(value, forKey: key)
        }
        synchronize()
    }
    
    func synchronize() {
        userDefaults.synchronize()
    }
}
