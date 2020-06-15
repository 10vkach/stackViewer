/*
 Набор методов для получения данных с сервера
 + сами данные загруженные с сервера
 */

import Foundation

public let stackLoader = StackLoader()

public class StackLoader {
    
    var questionsList: [Question] = []                          //Тут хранится список загруженных вопросов
    var questionDetailed: QuestionDetailed?                     //Вопрос с телом и ответами
    
    private let loadingQueue = DispatchQueue.global(qos: .utility)                              //Поток в котором будет происходить загрузка и парс данных
    
    private var loadingCompletion: ()->() = { }                                             //Код, который надо выполнить после успешной загрузки списка вопросов
    private var loadingErrorCompletion: (Error)->() = {_ in }                               //Выполнится при неуспешной загрузке списка вопросов
    
    private var loadingBodyCompletion: ()->() = {}                              //при удачной загрузке тела вопроса
    private var loadingBodyErrorCompletion: (Error)->() = {_ in }               //при неудачной загрузке тела вопроса
    
    //Загрузить первую страницу вопросов (использовать при смене тэга и запуске программы)
    func loadFirstPage(WithTag tag: String,                         //тэг, который отправится на сервер
                       completion: @escaping ()->(),                //Выполнится при успешном завершении загрузки
                       errorCompletion: @escaping (Error)->()) {    //Выполнится при неуспешном завершении загрузки
        
        loadingCompletion = {
            DispatchQueue.main.async {
                completion()
            }
        }
        loadingErrorCompletion = {
            error in
                DispatchQueue.main.async {
                    errorCompletion(error)
                }
            }
        //Загрузить данные в отдельном потоке
        if let url = getURL(ForPage: 1, WithTag: tag) {
            
            let task = URLSession.shared.dataTask(with: url,
                                                  completionHandler: {
                                                        self.parseFirstPageResponse(data: $0,
                                                                                    response: $1,
                                                                                    error: $2)
                                                        })
            loadingQueue.async {
                task.resume()
            }
        }
    }
    
    //Загрузить ещё одну страницу вопросов (не использовать для первой пачки вопросов)
    //Эту функцию надо сделать
    
    //Обработать ответ от сервера
    private func parseFirstPageResponse(data: Data?,
                                        response: URLResponse?,
                                        error: Error?) {
        
        //Если получили ошибку, то обработать её и прерваться
        if let errorSafe = error {
            loadingErrorCompletion(errorSafe)
            return
        }
        
        if let dataSafe = data {
            //распарсить данные и запихать их в массив
            do {
                let questionsListResponse: QuestionsList = try JSONDecoder().decode(QuestionsList.self, from: dataSafe)
                questionsList = questionsListResponse.items
                loadingCompletion()
            } catch let error {
                loadingErrorCompletion(error)
            }
        }
    }
    
    //Загрузить тело вопроса и после этого ответы
    func loadQuestionBody(WithID id: Int,
                          completion: @escaping ()->(),                //Выполнится при успешном завершении загрузки
                          errorCompletion: @escaping (Error)->()) {    //Выполнится при неуспешном завершении загрузки
        
        loadingBodyCompletion = {
            DispatchQueue.main.async {
                completion()
            }
        }
        loadingBodyErrorCompletion = {
            error in
            DispatchQueue.main.async {
                errorCompletion(error)
            }
        }
        //Загрузить данные в отдельном потоке
        if let url = getURL(ForQuestion: id) {
            
            let task = URLSession.shared.dataTask(with: url,
                                                  completionHandler: {
                                                    self.parseQuestionBodyResponse(data: $0,
                                                                                   response: $1,
                                                                                   error: $2)
                                                    })
            loadingQueue.async {
                task.resume()
            }
        }
    }
    
    //Распасить тело вопроса
    private func parseQuestionBodyResponse(data: Data?, response: URLResponse?, error: Error?) {
        //Если получили ошибку, то обработать её и прерваться
        if let errorSafe = error {
            loadingBodyErrorCompletion(errorSafe)
            return
        }
        if let dataSafe = data {
            do {
                //распарсить и сохранить вопрос
                let questionWithBody: QuestionsWithBody = try JSONDecoder().decode(QuestionsWithBody.self, from: dataSafe)
                if !questionWithBody.items.isEmpty {
                    questionDetailed = QuestionDetailed(
                        question: questionWithBody.items[0],
                        answers: [])
                    //загрузить ответы
                    loadAnswers(ForQuestionID: questionWithBody.items[0].question_id)
                }
            } catch let error {
                loadingBodyErrorCompletion(error)
            }
        }
    }
    
    private func loadAnswers(ForQuestionID id: Int) {
        //Загрузить данные в отдельном потоке
        if let url = getURL(ForAnswersByQuestionID: id) {
            let task = URLSession.shared.dataTask(with: url,
                                                  completionHandler: {
                                                    self.parseAnswers(data: $0,
                                                                      response: $1,
                                                                      error: $2)
            })
            loadingQueue.async {
                task.resume()
            }
        }
    }
    
    private func parseAnswers(data: Data?, response: URLResponse?, error: Error?) {
        //Если получили ошибку, то обработать её и прерваться
        if let errorSafe = error {
            loadingBodyErrorCompletion(errorSafe)
            return
        }
        if let dataSafe = data {
            do {
                //распарсить и сохранить ответы
                let answers: AnswersList = try JSONDecoder().decode(AnswersList.self, from: dataSafe)
                questionDetailed?.answers = answers.items
                loadingBodyCompletion()
            } catch let error {
                loadingBodyErrorCompletion(error)
            }
        }
        
    }
    
    //Запрос на получение ответов к вопросу
    private func getURL(ForAnswersByQuestionID id: Int) -> URL? {
        var request = URLComponents()
        request.scheme = "https"
        request.host = "api.stackexchange.com"
        request.path = "/2.2/questions/\(id)/answers"
        request.queryItems = [
            URLQueryItem(name: "site", value: "stackoverflow"),
            URLQueryItem(name: "order", value: "desc"),
            URLQueryItem(name: "filter", value: "withbody")
        ]
        return request.url
    }
    
    //Запрос на получение body вопроса
    private func getURL(ForQuestion questionID: Int) -> URL? {
        var request = URLComponents()
        request.scheme = "https"
        request.host = "api.stackexchange.com"
        request.path = "/2.2/questions/\(questionID)"
        request.queryItems = [
            URLQueryItem(name: "site", value: "stackoverflow"),
            URLQueryItem(name: "order", value: "desc"),
            URLQueryItem(name: "filter", value: "withbody")
        ]
        return request.url
    }
    
    //Создать запрос на получение списка вопросов с указанной страницей и тэгом
    private func getURL(ForPage page: Int,
                        WithTag tag: String) -> URL? {
        var request = URLComponents()
        request.scheme = "https"
        request.host = "api.stackexchange.com"
        request.path = "/2.2/questions"
        request.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "tagged", value: tag),
            URLQueryItem(name: "pagesize", value: "20"),
            URLQueryItem(name: "sort", value: "creation"),
            URLQueryItem(name: "site", value: "stackoverflow"),
            URLQueryItem(name: "order", value: "desc")
        ]
        return request.url
    }
}




//Вопросы начало
struct QuestionsList: Codable {
    let items: [Question]
}

struct Question: Codable {
    let question_id: Int
    let answer_count: Int
    let last_edit_date: Double?
    let title: String
    let owner: Owner
}

struct Owner: Codable {
    let display_name: String
}
//Вопросы конец

//Вопрос подробно начало
struct QuestionsWithBody: Codable {
    let items: [QuestionWithBody]
}

struct QuestionWithBody: Codable {
    let question_id: Int
    let body: String
    let last_edit_date: Double?
    let score: Int
    let owner: Owner
}
//Вопрос подробно конец

//Ответы начало

struct Answer: Codable {
    let last_activity_date: Double
    let body: String
    let is_accepted: Bool
    let score: Int
    let owner: Owner
}

struct AnswersList: Codable {
    let items: [Answer]
}
//Ответы конец

//Для хранения в классе
struct QuestionDetailed {
    var question: QuestionWithBody
    var answers: [Answer]
}
