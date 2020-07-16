/*
 Протоколы для обработки событий в классе StackLoader
 */

import Foundation

//События загрузки списка вопросов
protocol QuestionsLoaderDelegate: AnyObject {
    func questionsLoaded()
    func questionsLoaded(atIndeces: [Int])
    func questionsLoadingFail(error: Error)
}

//События загрузки определённого вопроса
protocol QuestionLoaderDelegate: AnyObject {
    func questionLoaded()
    func questionLoadingFail(error: Error)
}
