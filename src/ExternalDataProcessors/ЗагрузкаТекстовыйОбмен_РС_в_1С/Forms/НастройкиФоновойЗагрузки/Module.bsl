
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ГруппаНастройки.Доступность = Пользователи.ЭтоПолноправныйПользователь();

	ДополнительнаяОбработкаСсылка = Неопределено;
	ИдентификаторКоманды = Неопределено;
	Если Не Параметры = Неопределено Тогда
		Параметры.Свойство("ДополнительнаяОбработкаСсылка", ДополнительнаяОбработкаСсылка);
		Параметры.Свойство("ИдентификаторКоманды", ИдентификаторКоманды);
	КонецЕсли;
	ПараметрыОбработки = Новый Структура("ИдентификаторКоманды, ДополнительнаяОбработкаСсылка, ИмяФормы, КлючСессии");
	
	Если ДополнительнаяОбработкаСсылка = Неопределено и ИдентификаторКоманды = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ХранилищеНастроекОтчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДополнительнаяОбработкаСсылка, "ХранилищеНастроек");
	
	ПараметрыПоУмолчанию = РеквизитФормыВЗначение("Объект").ПараметрыПоУмолчанию();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыПоУмолчанию);
	
	Если ХранилищеНастроекОтчета <> Неопределено Тогда
		ЗначениеХранилищаНастроек = ХранилищеНастроекОтчета.Получить();
		Если ТипЗнч(ЗначениеХранилищаНастроек) = Тип("Структура") Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначениеХранилищаНастроек);
			МассивЗагружаемых = Неопределено;
			Если ЗначениеХранилищаНастроек.Свойство("МассивЗагружаемых", МассивЗагружаемых)
				И ТипЗнч(МассивЗагружаемых) = Тип("Массив") Тогда
				Для Каждого Элемент Из СписокЗагружаемыхОбъектов Цикл
					Элемент.Пометка = (МассивЗагружаемых.Найти(Элемент.Значение) <> Неопределено);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//Если НЕ ЗначениеЗаполнено(Параметры.ИдентификаторКоманды) ИЛИ Параметры.ИдентификаторКоманды = "ВыполнитьИнтерактивно" Тогда
	//	Отказ = Истина;
	//	ОткрытьФорму("ВнешняяОбработка.ЗагрузкаТекстовыйОбмен_РС_в_1С.Форма.Форма", Параметры);
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		СохранитьНаСервере();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНаСервере()

	МассивЗагружаемых = Новый Массив;
	Для Каждого ЭлементСписка Из СписокЗагружаемыхОбъектов Цикл
		Если ЭлементСписка.Пометка Тогда
			МассивЗагружаемых.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	НастройкиОбработки = Новый Структура;
	НастройкиОбработки.Вставить("МассивЗагружаемых",            МассивЗагружаемых);
	НастройкиОбработки.Вставить("Каталог",                      Каталог);
	НастройкиОбработки.Вставить("ПеремещатьВАрхивНеОтмеченные", ПеремещатьВАрхивНеОтмеченные);

	ДополнительнаяОбработкаОбъект = ДополнительнаяОбработкаСсылка.ПолучитьОбъект();
	ДополнительнаяОбработкаОбъект.ХранилищеНастроек = Новый ХранилищеЗначения(НастройкиОбработки);
	Попытка
		ДополнительнаяОбработкаОбъект.Записать();
	Исключение
	КонецПопытки;

КонецПроцедуры

&НаКлиенте
Процедура КаталогНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = ЛОЖЬ;
	
	Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
	ДиалогОткрытия = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытия.Каталог = Каталог;
	ДиалогОткрытия.Заголовок = "Выберите каталог с файлами для загрузки";
	
	Параметр = "";
	Оповещение = Новый ОписаниеОповещения("ВыборКаталога_Завершение", ЭтотОбъект, Параметр);
	ДиалогОткрытия.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКаталога_Завершение(Результат, Параметр) Экспорт
	
	Если Результат = Неопределено Тогда
		Сообщить("Каталог не выбран");
		Возврат;
	КонецЕсли;
	Каталог = Результат[0];
	
КонецПроцедуры
