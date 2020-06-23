/*
 Показывает барабан для выбора тэга
 */
import Foundation
import UIKit

class TagPickerView: UIPickerView, UIPickerViewDataSource {
    
    //MARK: Свойства
    //Список загружаемых тегов
    let tags: [String] = [
        "objective-c",
        "ios",
        "xcode",
        "cocoa-touch",
        "iphone"
    ]
    
    //MARK: Методы
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .lightGray
        alpha = 0.95
        dataSource = self
    }
    
    func show(inView view: UIView) {
        self.frame = view.bounds
        view.addSubview(self)
    }
    
    //MARK: PickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        tags.count
    }
    
}
