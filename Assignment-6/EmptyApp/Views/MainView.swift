import UIKit

@available(iOS 11.0, *)

class MainView: UIView {

    var menuButtons: [UIButton] = []
    var currentSubview: UIView?
    var windowManager: WindowManager?
   

    override init(frame: CGRect) {
        super.init(frame: frame)
        windowManager = WindowManager(containerView: self)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        let mainMenuView = UIView()
        let titles = ["Manage Programs", "Manage Courses", "Manage Course Categories", "Manage Colleges", "Exit"]
        for (index, title) in titles.enumerated() {
            let button = createButton(title: title, action: #selector(menuButtonTapped(sender:)))
            button.tag = index + 1
            menuButtons.append(button)
            mainMenuView.addSubview(button)
        }
        
        setupConstraints(for: mainMenuView)
        windowManager?.showView(mainMenuView)
    }

    func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    @objc func menuButtonTapped(sender: UIButton) {
        switch sender.tag {
        case 1:
            let collegeView = CollegeView(frame: bounds)
            collegeView.delegate = self
            windowManager?.showView(collegeView)
            currentSubview = collegeView
        case 4:
            let collegeView = CollegeView(frame: bounds)
            collegeView.delegate = self
            windowManager?.showView(collegeView)
            currentSubview = collegeView
        default:
            break
        }
    }

    func setupConstraints(for view: UIView) {
        for (index, button) in menuButtons.enumerated() {
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                button.topAnchor.constraint(equalTo: view.topAnchor, constant: 50 + CGFloat(index) * 60)
            ])
        }
    }
    
    func showMainMenu() {
        let mainMenuView = UIView()
        setupConstraints(for: mainMenuView)
        windowManager?.showView(mainMenuView)
    }
    
    
}

@available(iOS 11.0, *)
extension MainView: CollegeViewDelegate {
    func didTapBackButton(in collegeView: CollegeView) {
        showMainMenu()
    }
}
