/*
 Показывает кастомную крутилку на всю view(из метода set)
 */

import Foundation
import UIKit

class ActivityIndicatorViewFullScreen: UIActivityIndicatorView {
    
    //MARK: Методы
    override init(frame: CGRect) {
        super.init(frame: frame)
        customConfiguration()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        customConfiguration()
    }
    
    private func customConfiguration() {
        color = .black
        backgroundColor = .lightGray
        alpha = 0.9
    }
    
    func set(inView newSuperView: UIView) {
        frame = newSuperView.bounds
        newSuperView.addSubview(self)
    }
}
