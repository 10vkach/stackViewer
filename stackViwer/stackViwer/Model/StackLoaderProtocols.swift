/*
 Протоколы для обработки событий в классе StackLoader
 */

import Foundation

//События загрузки списка вопросов
protocol QuestionsLoaderDelegate {
    func questionsLoaded()
    func questionsLoadingFail(error: Error)
}

//События загрузки определённого вопроса
protocol QuestionLoaderDelegate {
    func questionLoaded()
    func questionLoadingFail(error: Error)
}
