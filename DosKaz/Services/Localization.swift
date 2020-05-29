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
	case complainSimply = "Подать жалобу"
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
	case myComplaints = "Мои тикеты"
	case downLoadComplaints = "Скачать жалобу"
	case eventsFeed = "Лента событий"
	case awards = "Достижения"
	case loadPhoto = "Загрузите фото"
	case personalInfo = "Персональная информация"
	case familyName = "Фамилия"
	case firstName = "Имя"
	case middleName = "Отчество"
	case iin = "ИИН"
	case street = "Улица"
	case rememberMyData = "Запомнить мои данные"
	case phone = "Телефон"
	case city = "Город"
	case authority = "Наименование органа обращения"
	case complaint = "Жалоба"
	case objectName = "Название объекта"
	case complaintType = "Вид жалобы"
	case complaintTypeOne = "Жалоба на отсутствие пандуса / подъемника на входе в объект"
	case complaintTypeTwo = "Жалоба на отсутствие доступа на объект или несоответствии функциональных зон объекта требованиям нормативного законодательства"
	case visitPurpose = "Цель посещения объекта"
	case lifeThreat = "Данными условиями создана угроза причинения вреда моей жизни и здоровью (отметить, если это так)"
	case additional = "Приложения"
	case building = "Дом"
	case apartment = "Квартира"
	case dateOfVisit = "Дата посещения объекта"
	case objectBuildingNumber = "Номер дома"
	case objectOfficeNumber = "Офис (если есть)"
	case complaintHeader = "Внимание! В связи с тем, что Ваше письмо в дальнейшем будет направлено в государственный орган, оно должно выполнять определенные требования, такие как наличие Ф.И.О., ИИН, адреса (пункт 2 статьи 6 Закона Республики Казахстан от 12.01.2007 г. № 221-III «О порядке рассмотрения обращений физических и юридических лиц»). Пожалуйста, заполните данные поля без ошибок. Анонимные обращения не рассматриваются.\n\nПоля, обязательные для заполнения"
	case complaint2Header = "Выберите из списка что именно вас не устроило на объекте, либо оставьте комментарий"
	case level = "уровень"
	case helpSomebody = "Помогая другим, помогаешь себе"
	case currentTask = "Текущее задание"
	case ofObjects = "объектов"
	case ofInvestigations = "проверок"
	case points = "баллов"
	case other = "Другое"
	case textOftheMessage = "Текст сообщения"
	case yourComments = "Ваши комментарии"
	case chooseObject = "Выберите объект"
	case photo = "Фото"
	case reviews = "Отзывы"
	case history = "История"
	case video = "Видео"
	case notVerified = "Объект не верифицирован"
	
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
