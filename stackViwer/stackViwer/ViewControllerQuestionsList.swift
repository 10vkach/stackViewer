/*
 
 */

import Foundation
import UIKit

class ViewControllerQuestionsList: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let tags: [String] = [
        "objective-c",
        "ios",
        "xcode",
        "cocoa-touch",
        "iphone"
    ]
    
    let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Добавить кнопку для выбора тэга
        let button = UIBarButtonItem(title: "Tag",
                                     style: .plain,
                                     target: self,
                                     action: #selector(ViewControllerQuestionsList.showTagSelector))
        navigationItem.setLeftBarButton(button, animated: false)
        
        //Настройка pickerView
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.frame = CGRect(x: 0,
                                  y: navigationController!.navigationBar.frame.maxY,
                                  width: UIScreen.main.bounds.width,
                                  height: UIScreen.main.bounds.height - navigationController!.navigationBar.frame.maxY)
        pickerView.backgroundColor = .lightGray
        pickerView.alpha = 0.8
    }
    
    //Показать окно выбора тэга
    @objc func showTagSelector() {
        if pickerView.superview == nil {
            tableView.isScrollEnabled = false              //Чтобы не было прокрутки во время выбора тега
            navigationController?.view.addSubview(pickerView)
        } else {
            pickerView.removeFromSuperview()
        }
    }
    
//TableView start
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "OpenViewControllerQuestion", sender: self)
    }
//TableView end
    
//PickerView start
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tags.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return tags[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        pickerView.removeFromSuperview()
        
        //Если выбран другой тег, то загрузить новые вопросы
        if navigationItem.title != tags[row] {
            //Загрузить вопросы по тэгу
        }
        
        navigationItem.title = tags[row]
        
        tableView.isScrollEnabled = true                       //Включить выключенную возможность
    }
    
//PickerView end
}
