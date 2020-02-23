//
//  AppSettings.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 2/23/20.
//  Copyright © 2020 zed. All rights reserved.
//
import Foundation


extension AppSettings {
	
	//MARK: Language
	static var language: Settings.Language? {
		get {
			guard let rawLang: String = AppSettings.value(for: Keys.language) else { return nil }
			return Settings.Language(rawValue: rawLang)
		}
		set(newLanguage) {
			AppSettings.updateDefaults(for: Keys.language, value: newLanguage!.rawValue)
		}
	}
	
}

extension Keys {
	static let language = "language"
}




// TODO: Add to Shared

struct Keys {
	
}

class AppSettings {
		
	//MARK: - Defaults read/write methods
	
	private static func updateDefaults(for key: String, value: Any) {
		// Save value into UserDefaults
		UserDefaults.standard.set(value, forKey: key)
	}
	
	private static func value<T>(for key: String) -> T? {
		// Get value from UserDefaults
		return UserDefaults.standard.value(forKey: key) as? T
	}
}


struct Settings {
	let lang: Language = .russian
		
	enum Language: String, CustomStringConvertible {
		
		// Never change these otherwise Localizable strings won't work
		case kazakh = "kk"
		case russian = "ru"
	
		var description: String {
			switch self {
			case .kazakh: return "Қазақша"
			case .russian: return "Русский"
			}
		}
		
	}
	
}
