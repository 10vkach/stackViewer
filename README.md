# stackViewer
## Общее описание
Написать мобильные приложение для на языке Swift. Приложение представляет из себя клиент для http://stackoverflow.com/. Ссылка на документацию по API: https://api.stack-exchange.com/docs.

Приложение должно содержать 2 экрана:
1) ### Список вопросов по выбранному тэгу.
Набор тэгов ограничен и задан следующим множеством: (objective-c, ios, xcode, cocoa-touch, iphone).
По умолчанию отображается список последних 20 вопросов по тэгу objective-c. Сменить тэг можно нажав на левую верхнюю кнопку в NavigationBar-е и выбрав его из появившегося списка в UIPickerView. При выборе нового тэга отображается Activity-индикатор на время загрузки 20 вопросов по новому тэгу, после чего список обновляется. Название тэга обновляется в NavigationBar-e.

В списке вопросов должно быть:
 - Название вопроса (максимум 2 строки, если не влезает - должно обрезаться) 
 - Количество ответов
 - Ник автора вопроса
 - Дата последней модификации
 2) ### Детальный экран вопроса.
 Ячейка вопроса имеет background отличный от ячеек ответов и содержит те же данные, что и ответы, кроме галочки. Далее отображается список ответов без комментариев к ним.
 
 Ячейка ответа должна содержать:
 - Полный текст ответа
 - Дату последней модификации
 - Ник автора ответа
 - Количество голосов
 - Галочка, если ответ помечен, как правильный

Полный текст сообщения приходит в формате html. Необходимо удалить из строки все тэги и обрабатывать только перенос строки (\<br> и \</br>).

## Требования к коду
1. Для навигации между экранами должен использоваться UINavigationController
2. Пользовательский интерфейс приложения должен быть настроен в InterfaceBuilder
(в Storiboard или Xib файлы).
3. Вывод информационных сообщений должен быть реализован с помощью UIAlertController.
4. Расположение элементов пользовательского интерфейса должно задаваться либо
констрэйнтами либо autoresizingMask’ами.

## Дополнительные задания
1. Текст в тэге \<code>\</code> должен быть выделен цветом бэкграунда и написан моноширинным шрифтом.
2. Вывод даты последней модификации в «умном» формате — modified 30 secs ago, modified 1 hour ago (если больше 24 часов, то просто дата).
3. Пейджинг списка вопросов: при прокрутке списка до последнего вопроса подгружаются следующие 20 вопросов.
4. Обновление списка вопросов и детальной страницы вопроса по pull down to refresh.
