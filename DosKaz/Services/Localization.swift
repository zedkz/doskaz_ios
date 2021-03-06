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
	case description = "Описание"
	case detailInfo = "Подробная информация"
	case verifyInfo = "Подтвердить данные"
	case complain = "Подать жалобу на объект"
	case complainSimply = "Подать жалобу"
	case accessibleFull = "Доступно"
	case accessiblePartial = "Частично доступно"
	case accessibleNone = "Не доступно"
	case accessbleNotProvided = "Не предоставлено"
	case accessibleUnknown = "Неизвестно"
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
	case formFull = "Сложная форма"
	case fillTheField = "Поле должно быть заполнено"
	case objName = "Наименование"
	case objAddress = "Адрес"
	case objOnMap = "Объект на карте"
	case objCategory = "Категория"
	case objSubCategory = "Подкатегория"
	case videoLink = "Ссылка на видео (не обязательно)"
	case genInfo = "Общая информация"
	
	case instruction = "Инструкция"
	case instructionTextZero = "Добро пожаловать!\n\nПриветствуем вас на онлайн-карте «Доступный Казахстан», с помощью которой вы сможете получить информацию о доступности городских объектов и услуг для людей, передвигающимся на креслах-колясках, маломобильных групп населения, а также людей с инвалидностью по зрению и слуху."
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
	case tellUsAboutYourFeelings = "Расскажите о ваших впечатлениях"
	case enter20Symbols = "Введите минимум 20 символов"
	case writeReview = "Написать отзыв"
	case yourReviewWasReceived = "Ваш отзыв принят"
	case aboutProject = "О проекте"
	case aboutHeadingWhatIsThisProject = "Что представляет собой проект"
	case doskaz = "«Доступный Казахстан»"
	case aboutTextWhatIsThisProject = "«Доступный Казахстан» — это онлайн-карта, на которую нанесена информация о доступности городских объектов и услуг. Открытые и бесплатные данные на карте дают возможность маломобильным группам населения (включая людей с инвалидностью, родителей с маленькими детьми на колясках, пожилых, беременных, временно-травмированных) ориентироваться в городском пространстве, а в случае отсутствия объекта на карте удобный интерфейс предоставляет возможность любому желающему поделиться со всеми информацией о доступности объекта."
	case aboutHowMapWorks = "Как работает карта"
	case aboutTextHowMapWorks = "Доступность объектов для маломобильных групп населения обозначена на карте международной системой светофора:"
	case aboutAvailable = "Зеленая иконка обозначает, что объект полностью доступен, его можно посетить и воспользоваться услугами самостоятельно, без посторонней помощи."
	case aboutPartial = "Желтая иконка — объект частично доступен, для посещения данного объекта нужна посторонняя помощь, либо не все его функциональные зоны доступны."
	case aboutNotAvailable = "Красная иконка — объект недоступен, попасть на объект невозможно из-за недоступности входной группы (например, нет пандуса), либо невозможности движения по объекту."
	case aboutParticipate = "Стань участником проекта"
	case aboutTextParticipate = "На этапе запуска карты обученные волонтеры собрали информацию о более 2000 общественных объектов, есть не только фото-, но и видеообзоры. Мы возлагаем большие надежды именно на ВАС, на тех, кто пользуется картой, кому она ежедневно помогает получать актуальную информацию о доступности городских объектов! Мы позиционируем карту как сообщество, и надеемся, что ВЫ станете ее активным членом, полноценным участником и будете сами добавлять объекты на карту, а также комментировать и дополнять информацию об уже отраженных на карте объектах. \nПри самостоятельном размещении на карте нового объекта, пожалуйста, оставляйте в комментариях как можно более подробную информацию и прикрепляйте фотографии, ведь именно эти материалы помогут другому человеку ориентироваться в городской среде."
	
	case aboutHeadingWhyNeedMap = "Почему эта карта необходима?"
	case aboutWhyNeedMap = "Зайдя на карту, вы сразу же увидите, что множество объектов отмечены красной иконкой. Так получилось не потому, что на карту специально заносились недоступные объекты, а потому, что доступных и частично доступных объектов в населенных пунктах намного меньше. Организации обязаны сделать вход в здание доступным для всех, но в большинстве случаев либо пандус не соответствует нормативам, либо человек, даже попав в здание, не может воспользоваться услугами, так как на его пути встречается мебель в узких коридорах, лестницы, а лифты отсутствуют и т.п."
	case aboutWhyNeedMap2 = "Мы все — граждане своей страны с одинаковыми правами, отраженными в Конституции. Считаете ли вы, что ограничение в доступе к объектам и услугам является нарушением наших прав? Мы в этом уверены. 20 февраля 2015 года в Нур-Султане была ратифицирована Конвенция о правах людей с инвалидностью, после чего наше государство взяло на себя обязанность обеспечить благоприятную среду жизнедеятельности для людей с инвалидностью. В ближайшей перспективе Конвенция должна максимально ускорить процесс стирания барьеров, мешающих людям с инвалидностью полноценно участвовать в жизни общества наравне с другими гражданами."
	case aboutWhyNeedMap3 = "Доступность открывает путь к получению образования, трудоустройству, лечению, отдыху, к возможности вести независимый образ жизни. Безбарьерная среда является общественным благом и тесно связана с социальным и экономическим развитием страны. Пусть термин «безбарьерная среда» для многих уже приобрел окрас разочарования, но мы надеемся и верим, что безбарьерная среда — это ближайшая реальность, и данная карта один из инструментов ее приближения!"
	
	case aboutHeadingProjectUsefull = "Реальная польза проекта"
	case aboutTextProjectUsefull = "Информация на карте поможет не только эффективно распланировать свой день и передвижения по городу, но и будет способствовать созданию инклюзивной среды.\nПри разработке карты была создана функция сбора данных об объектах — администратор карты в любой момент может предоставить статистические данные о количестве доступных или недоступных для посещения городских объектах. Представленные данные — это актуальный инструмент, показывающий реальную ситуацию в населенном пункте, необходимый для неправительственных и государственных организаций."
	
	case aboutHeadingPartners = "Реализация проекта"
	case aboutTextPartners = "Проект реализуется консорциумом общественных организаций. Смотрите страницу Контакты."
	case aboutHeadingFinancing = "Финансирование"
	case aboutTextFinancing = "Проект финансируется Европейским Союзом и Дипломатической миссией США в Казахстане."
	case date = "Дата"
	case save = "Сохранить"
	case choose = "Выберите"
	case commentaryText = "Текст комментария"
	case zoneScoreInfoText = "Система оценила доступность. Если вы не согласны с оценкой, вы можете оставить комментарий с пояснением"
	case zoneScore = "Оценка доступности зоны"
	case movementZoneScoreText = "Люди, передвигающиеся на кресло-коляске"
	case limb = "Люди с нарушениями опорно-двигательного аппарата"
	case vision = "Люди с инвалидностью по зрению"
	case hearing = "Люди с инвалидностью по слуху"
	case intellectual = "Люди с интеллектуальной инвалидностью"
	case toObject = "к объекту"
	case editing = "Редактирование"
	case editProfile = "Редактирование профиля"
	case fillProfile = "За заполнение анкеты вы получите 70 баллов. Ваша личная информация не будет видна другим пользователям"
	case email = "Эл. почта"
	case status = "Отображаемый статус"
	case yourName = "Ваше имя"
	case yourStatus = "Ваш статус"
	case contactsInfo = "Вы можете связаться с нами по электронной почте, через колл-центр или же заполнив форму.\n\nКолл-центр работает в рабочие дни с 09:00 до 18:00"
	case contacts = "Контакты"
	case writeToUs = "Напишите нам"
	case send = "Отправить"
	case regionalReps = "Региональные представители"
	case emailIsWrong = "Неправильный формат электронной почты"
	case similarContent = "Похожие материалы"
	case comments = "Комментарии"
	case reply = "Ответить"
	case replies = "Ответы"
	case auth = "Авторизация"
	case welcome = "Добро пожаловать на портал!"
	case next = "Далее"
	case toProfile = "Перейти в мой профиль"
	case enterNumberAgain = "Ввести номер заново"
	case nextTime = "В другой раз"
	case enterPhone = "Введите номер мобильного телефона"
	case enterSmsCode = "Введите код из СМС"
	case continueReg = "Продолжите регистрацию и заполните свой профиль"
	case getTwentyPoints = "За регистрацию вам начислено 20 баллов"
	case getFiftyPoints = "Заполните информацию о себе и получите ещё 50 баллов"
	case smsInfo = "Если вы не получили смс-код, убедитесь что ваше устройство прошло регистрацию у сотового оператора"
	case objectNameExists = "Объект с таким наименованием существует"
	case objectNameOtherNameExists = "Объект с таким наименованием и другим названием существует"
	case objectOtherNameExists = "Объект с таким другим названием существует"
	case verifyObjectData = "Подтвердите данные об объекте: "
	case verifyObjectDataMessage = "Считаете ли вы, что все данные об объекте заполнены верно?"
	case yes = "Да"
	case no = "Нет"
	case foundErrors = "Нашли ошибку?"
	case foundErrorsMessage = "Пожалуйста, оставьте свой отзыв. Это не займёт много времени, но поможет сделать наш сайт лучше."
	case yesHelp = "Да, я хочу помочь"
	case cancel = "Отменить"
	case categories = "Категории"
	case fullVerified = "Объект верифицирован"
	case partiallyVerified = "Объект частично верифицирован"
	case categoryOfUser = "Категория пользователя"
	case language = "Язык"
	case back = "Назад"
	case all = "Все"
	case avatarChoice = "Выбор аватара"
	case deleteAvatar = "Удалить аватар"
	case choosePresetAvatar = "Выбрать из готовых"
	case chooseFromPhotoGallery = "Загрузить из фотогалереи"
	case signOut = "Выйти из профиля?"
	case reviewCreated = "написал(а) отзыв"
	case verificationConfirmed = "подтвердил(а) объект"
	case verificationRejected = "не подтвердил(а)"
	case objectAddSucceeded = "Ваш запрос принят. Объект появиться на карте в течение суток после проверки модератором."
	case award_issued = "Вам выдана награда"
	case currentLevel = "Поздравляем, вы достигли уровень:"
	case nextLevel = "Баллов до следующего уровня:"
	case abilityStatusChange = "Теперь вы можете сменить статус.";
	case abilityAvatarUpload = "Теперь вы можете сменить аватар.";
	case hasCommented = "прокомментировал(а) ваш объект";
	case hasCommentedBlog = "ответил(а) на ваш комментарий к посту"
	case youAddedObject = "Вы добавлили объект"
	case kidsAccessibility = "Доступность и безопасность услуг для детей до 7 лет"
	case supplementedVenue = "дополнил(а) объект"
	
	var l10n: String {
		let enumCaseName = String(describing: self)
		return enumCaseName.localized
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
