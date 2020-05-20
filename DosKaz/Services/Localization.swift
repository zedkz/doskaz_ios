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
	case map = "Карта"
	case searchPlaceholder = "Название или адрес"
	case greetingHeading1 = "Проверьте доступность"
	case greetingHeading2 = "Добавьте объект"
	case greetingHeading3 = "Будьте в курсе"
	case greeting1 = "Доступность объектов обозначена системой светофора: зеленая иконка обозначает полностью доступные объекты, желтая — частично доступные, красная — недоступные объекты."
	case greeting2 = "В случае отсутствия объекта на карте, вы можете сами разместить о нем информацию, воспользовавшись функцией «Добавить объект», потратив на это пару минут. Для этого вам понадобятся фотографии объекта, сделанные вами."
	case greeting3 = "Также на сайте карты вы сможете ознакомиться с различными полезными материалами в разделе «Блог». Там вы найдете советы, рекомендации, анонсы мероприятий и много другое."
	case description = "ОПИСАНИЕ"
	case detailInfo = "Подробная информация"
	case verifyInfo = "Подтвердить данные"
	case complain = "Подать жалобу на объект"
	case accessibleFull = "Доступно"
	case accessiblePartial = "Частично доступно"
	case accessibleNone = "Не доступно"
	case accessbleNotProvided = "Неизвестно"
	case parking = "Парковка"
	case entrance = "Входная группа"
	case movement = "Пути движения по объекту"
	case service = "Зона оказания услуги"
	case toilet = "Туалет"
	case navigation = "Навигация"
	case serviceAccessibility = "Доступность услуги"
	case showOnMap = "Показать на карте"
	case filter = "Фильтрация"
	case objectAccessibility = "Доступность объекта"
	case objectCategories = "Категории объектов"
	case done = "Готово"
	case pickAll = "Выбрать всё"
	case clearAll = "Сбросить"
	case addObject = "Добавить объект"
	case formSmall = "Простая форма"
	case formMedium = "Средняя форма"
	case formFull = "Большая форма"
	case fillTheField = "Поле должно быть заполнено"
	case objName = "Наименование"
	case objAddress = "Адрес"
	case objOnMap = "Объект на карте"
	case objCategory = "Категория"
	case objSubCategory = "Подкатегория"
	case videoLink = "Ссылка на видео (не обязательно)"
	case genInfo = "Общая информация"
	
	case instruction = "Инструкция"
	case instructionTextZero = """
	Добро пожаловать!
	
	Приветствуем вас на онлайн-карте «Доступный Павлодар», с помощью которой вы сможете получить информацию о доступности городских объектов и услуг для людей, передвигающимся на креслах-колясках, маломобильных групп населения, а также людей с инвалидностью по зрению и слуху.
	"""
	case blog = "Блог"
	case profile = "Профиль"
	case more = "Еще"
	case otherNames = "Другие названия"
	case succeedFormMessage = "Ваш запрос принят"
	case errorMessage = "Произошла ошибка, попробуйте позже"
	case close = "Закрыть"
	case edit = "Редактировать"

	case myProfile = "Мой профиль"
	case myTasks = "Мои задания"
	case myObjects = "Мои объекты"
	case oldFirst = "Сначала старые"
	case newFirst = "Сначала новые"
	case myComments = "Мои комментарии"
	
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
