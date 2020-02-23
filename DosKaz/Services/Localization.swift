//
//  Localization.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 2/23/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Foundation



/// Convenience method for getting localizable string
/// - Parameter localizableString: key from the LocalizableStringKeyValue list
/// - Returns: localized string from the string files

func l10n(_ localizableString: LocalizableStringKeyValue) -> String {
	return localizableString.l10n
}


/// Central resource OR source of truth for localizable
/// strings. String files are generated from this enum
/// and app code uses this to display strings

enum LocalizableStringKeyValue: String, CaseIterable {
	case blog    = "Блог"
	case profile = "Профиль"
	case профиль
	case page = "Страница"
	
	var l10n: String {
		return self.rawValue.localized
	}
}

fileprivate extension String {
		
	var localized: String {
		guard let langBundle = langBundle else { return self }
		return langBundle.localizedString(forKey: self, value: nil, table: nil)
	}
	
	private var langBundle: Bundle? {
		guard let lang = AppSettings.language?.rawValue else { return nil }
		guard let path = Bundle.main.path(forResource: lang, ofType: "lproj") else { return nil }
		
		return Bundle(path: path)
	}
	
}
