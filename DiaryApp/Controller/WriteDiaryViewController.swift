//
//  WriteDiaryViewController.swift
//  DiaryApp
//
//  Created by 김하은 on 2023/09/23.
//

import UIKit

//MARK: - Enum
enum DiaryEditorMode {
    case new
    case edit(IndexPath, Diary)
}

//MARK: - Protocol
protocol WriteDiaryViewDelegate: AnyObject {
    func didSelectRegister(diary: Diary)
}

//MARK: - class
class WriteDiaryViewController: UIViewController {
    
    // MARK: - var, let
    var titleLabel: UILabel!
    var titleTextField: UITextField!
    var contentsLabel: UILabel!
    var contentsTextView: UITextView!
    var dateLabel: UILabel!
    var dateTextField: UITextField!
    var backButton: UIBarButtonItem!
    var confirmButton: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    
    var diaryEditorMode: DiaryEditorMode = .new
    
    weak var delegate: WriteDiaryViewDelegate?
    
    // MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
        configureEditMode()
        configureInputField()
        confirmButton.isEnabled = false
    }
    
    // Keyboard 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: - UI
    private func setupUI() {
        let borderColor = CGColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        
        // 제목
        titleLabel = UILabel()
        titleLabel.text = "제목"
        titleLabel.textColor = .black
        titleTextField = UITextField()
        titleTextField.layer.borderColor = borderColor
        titleTextField.layer.borderWidth = 0.5
        titleTextField.layer.cornerRadius = 5
        
        // 내용
        contentsLabel = UILabel()
        contentsLabel.text = "내용"
        contentsLabel.textColor = .black
        contentsTextView = UITextView()
        contentsTextView.layer.borderColor = borderColor
        contentsTextView.layer.borderWidth = 0.5
        contentsTextView.layer.cornerRadius = 5
        
        // 날짜
        dateLabel = UILabel()
        dateLabel.text = "날짜"
        dateTextField = UITextField()
        dateTextField.layer.borderColor = borderColor
        dateTextField.layer.borderWidth = 0.5
        dateTextField.layer.cornerRadius = 5
        
        backButton = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backButtonTapped))
        confirmButton = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(confirmButtonTapped(_:)))

        // Then, add them to the view hierarchy like this:
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(contentsLabel)
        view.addSubview(contentsTextView)
        view.addSubview(dateLabel)
        view.addSubview(dateTextField)
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = confirmButton
        
        // Configure the date picker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        dateTextField.inputView = datePicker
        
        // titleLabel constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        // titleTextField constraints
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // // contentsLabel constraints constraints
        contentsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentsLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20).isActive = true
        contentsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        contentsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        // contentsTextView constraints
        contentsTextView.translatesAutoresizingMaskIntoConstraints = false
        contentsTextView.topAnchor.constraint(equalTo: contentsLabel.bottomAnchor, constant: 20).isActive = true
        contentsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        contentsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        contentsTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        // dateLabel constraints
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: contentsTextView.bottomAnchor, constant: 20).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        // dateLabel constraints
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20).isActive = true
        dateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        dateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        contentsTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    //MARK: - Action
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func confirmButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextField.text else { return }
        guard let contents = self.contentsTextView.text else { return }
        guard let date = self.diaryDate else { return }
        
        switch self.diaryEditorMode {
        case .new:
            let diary = Diary(
                uuidString: UUID().uuidString,
                title: title,
                contents: contents,
                date: date,
                isStar: false
            )
            self.delegate?.didSelectRegister(diary: diary)
        case let .edit(_, diary):
            let diary = Diary(
                uuidString: diary.uuidString,
                title: title,
                contents: contents,
                date: date,
                isStar: diary.isStar)
            NotificationCenter.default.post(  //post to "WriteDiaryViewController, DiaryDetailViewController, ViewController"
                name: NSNotification.Name("editDiary"),
                object: diary,
                userInfo: nil
            )
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Method
    private func configureEditMode() {
        switch self.diaryEditorMode {
        case let .edit(_, diary):
            self.titleTextField.text = diary.title
            self.contentsTextView.text = diary.contents
            self.dateTextField.text = dateToString(date: diary.date)
            self.diaryDate = diary.date
            self.confirmButton.title = "수정"
        default:
            break
        }
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }

    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 (EEEEE)" //ex) 2021년 12월 20일 (Fri)
        formatter.locale = Locale(identifier: "ko_KR") //ex) Fri -> 금
        self.diaryDate = datePicker.date
        self.dateTextField.text = formatter.string(from: datePicker.date)
        self.dateTextField.sendActions(for: .editingChanged)
    }
    //confirmButton Enable or not
    private func configureInputField() {
        self.contentsTextView.delegate = self
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @objc private func dateTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    private func validateInputField() {
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
    }
}

//MARK: - Extension
extension WriteDiaryViewController: UITextViewDelegate/*UITextFieldDelegate*/ {
    func textViewDidChange(_ textView: UITextView) {
        self.validateInputField()
    }
}
