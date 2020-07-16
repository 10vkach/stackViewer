/*
 Набор методов для получения данных с сервера
 + сами данные загруженные с сервера
 */

import Foundation

class StackLoader {
    
    //MARK: Свойства
    var totalQuestions: Int = 0                                 //Общее количетсво вопросов
    var questionsList: [Question] = []                          //Тут хранится список загруженных вопросов
    var questionDetailed: QuestionDetailed?                     //Вопрос с телом и ответами
    var pagesLoaded: Int = 0                                    //Количество загруженных страниц
    var isPageLoading = false                                     //Происходит ли загрузка в данный момент
    
    var questionsLoaderDelegate: QuestionsLoaderDelegate?
    var questionLoaderDelegate: QuestionLoaderDelegate?
    
    //Группа для загрузки тела вопросов и ответов на него
    private let dispatchGroupForQuestionLoad = DispatchGroup()
    //Пустая "заглушка", нужна при сохранении распасенного ответа
    private let questionWithBodyCash = QuestionWithBody(
        question_id: 0,
        body: "",
        last_edit_date: 0.0,
        score: 0,
        owner: Owner(display_name: ""))
    
    //MARK: Методы
    
    
    
    //MARK: Загрузить вопросы
    //Загрузить первую страницу вопросов (использовать при смене тэга и запуске программы)
    func loadFirstPage(withTag tag: String) {
        guard isPageLoading == false else { return }
        //Загрузить данные в отдельном потоке
        if let url = getURL(ForPage: 1, WithTag: tag) {
            isPageLoading = true
            
            let task = URLSession.shared.dataTask(with: url,
                                                  completionHandler: {
                                                        self.isPageLoading = false
                                                        self.parseFirstPageResponse(data: $0,
                                                                                    response: $1,
                                                                                    error: $2)
                                                        })
            task.resume()
        }
    }
    
    //Обработать ответ от сервера
    private func parseFirstPageResponse(data: Data?,
                                        response: URLResponse?,
                                        error: Error?) {
        
        //Если получили ошибку, то обработать её и прерваться
        if let errorSafe = error {
            DispatchQueue.main.async {
                self.questionsLoaderDelegate?.questionsLoadingFail(error: errorSafe)
            }
            return
        }
        
        if let dataSafe = data {
            //распарсить данные и запихать их в массив
            do {
                let questionsListResponse: QuestionsList = try JSONDecoder().decode(QuestionsList.self, from: dataSafe)
                questionsList = questionsListResponse.items
                totalQuestions = questionsListResponse.total
                pagesLoaded = 1
                DispatchQueue.main.async {
                    self.questionsLoaderDelegate?.questionsLoaded()
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.questionsLoaderDelegate?.questionsLoadingFail(error: error)
                }
            }
        }
    }
    
    //Загрузить ещё одну страницу вопросов (не использовать для первой пачки вопросов)
    func loadNextPage(withTag tag: String) {
        guard isPageLoading == false else { return }
        guard let url = getURL(ForPage: pagesLoaded + 1, WithTag: tag) else { return }
        
        isPageLoading = true
        let task = URLSession.shared.dataTask(with: url,
                                              completionHandler: {
                                                    self.isPageLoading = false
                                                    self.parseNextPageResponse(data: $0,
                                                                              response: $1,
                                                                              error: $2)
                                                    })
            task.resume()
    }
    
    private func parseNextPageResponse(data: Data?,
                                       response: URLResponse?,
                                       error: Error?) {
        //Если получили ошибку, то обработать её и прерваться
        if let errorSafe = error {
            DispatchQueue.main.async {
                self.questionsLoaderDelegate?.questionsLoadingFail(error: errorSafe)
            }
            return
        }
        
        if let dataSafe = data {
            //распарсить данные и запихать их в массив
            do {
                let questionsListResponse: QuestionsList = try JSONDecoder().decode(QuestionsList.self, from: dataSafe)
                let startIndex = questionsList.count
                questionsList += questionsListResponse.items
                pagesLoaded += 1
                let endIndex = questionsList.count
                let newIndeces = (startIndex..<endIndex).map({ $0 })
                DispatchQueue.main.async {
                    self.questionsLoaderDelegate?.questionsLoaded(atIndeces: newIndeces)
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.questionsLoaderDelegate?.questionsLoadingFail(error: error)
                }
            }
        }
    }
    
    //MARK: Загрузить вопрос и ответы
    func loadQuestionAndAnswers(questionID: Int) {
        loadQuestionBody(withID: questionID)
        loadAnswers(ForQuestionID: questionID)
        dispatchGroupForQuestionLoad.notify(queue: DispatchQueue.main, execute: {
            self.questionLoaderDelegate?.questionLoaded() })
    }
    
    //MARK: Загрузить вопрос
    //Загрузить тело вопроса и после этого ответы
    func loadQuestionBody(withID id: Int) {
        dispatchGroupForQuestionLoad.enter()
        
        //Загрузить данные в отдельном потоке
        if let url = getURL(ForQuestion: id) {
            
            let task = URLSession.shared.dataTask(
                with: url,
                completionHandler: {
                    self.parseQuestionBodyResponse(data: $0,
                                                   response: $1,
                                                   error: $2)
                })
            task.resume()
        }
    }
    
    //Распасить тело вопроса
    private func parseQuestionBodyResponse(data: Data?, response: URLResponse?, error: Error?) {
        //Если получили ошибку, то обработать её и прерваться
        if let errorSafe = error {
            questionLoaderDelegate?.questionLoadingFail(error: errorSafe)
            return
        }
        if let dataSafe = data {
            do {
                //распарсить и сохранить вопрос
                let questionWithBody: QuestionsWithBody = try JSONDecoder().decode(QuestionsWithBody.self, from: dataSafe)
                if !questionWithBody.items.isEmpty {
                    if questionDetailed == nil {
                        questionDetailed = QuestionDetailed(
                            question: questionWithBody.items[0],
                            answers: [])
                    } else {
                        questionDetailed?.question = questionWithBody.items[0]
                    }
                }
            } catch let error {
                questionLoaderDelegate?.questionLoadingFail(error: error)
            }
        }
        self.dispatchGroupForQuestionLoad.leave()
    }
    
    //MARK: Загрузить ответы
    private func loadAnswers(ForQuestionID id: Int) {
        dispatchGroupForQuestionLoad.enter()
        
        //Загрузить данные в отдельном потоке
        if let url = getURL(ForAnswersByQuestionID: id) {
            let task = URLSession.shared.dataTask(
                with: url,
                completionHandler: {
                    self.parseAnswers(data: $0,
                                      response: $1,
                                      error: $2)
                })
                task.resume()
        }
    }
    
    private func parseAnswers(data: Data?, response: URLResponse?, error: Error?) {
        //Если получили ошибку, то обработать её и прерваться
        if let errorSafe = error {
            DispatchQueue.main.async {
                self.questionLoaderDelegate?.questionLoadingFail(error: errorSafe)
            }
            return
        }
        if let dataSafe = data {
            do {
                //распарсить и сохранить ответы
                let answers: AnswersList = try JSONDecoder().decode(AnswersList.self, from: dataSafe)
                if questionDetailed == nil {
                    questionDetailed = QuestionDetailed(question: questionWithBodyCash, answers: answers.items)
                } else {
                    questionDetailed?.answers = answers.items
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.questionLoaderDelegate?.questionLoadingFail(error: error)
                }
            }
        }
        
        self.dispatchGroupForQuestionLoad.leave()
    }
    
    //MARK: Формирование URL
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
            URLQueryItem(name: "order", value: "desc"),
            //Чтобы в ответе было общее количество вопросов.
            URLQueryItem(name: "filter", value: "!9_bDE.BDp")
        ]
        return request.url
    }
    
    deinit {
        print("deinit StackLoader")
    }
}
