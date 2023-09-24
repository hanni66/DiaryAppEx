//
//  StarViewController.swift
//  DiaryApp
//
//  Created by 김하은 on 2023/09/23.
//

import UIKit

class StarViewController: UIViewController {
    
    //MARK: var
    var collectionView: UICollectionView!
    
    private var diaryList = [Diary]()
    
    //MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        loadStarDiaryList()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryNotification(_:)),
            name: NSNotification.Name("editDiary"),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(starDiaryNotification(_:)),
            name: NSNotification.Name("starDiary"),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deleteDiaryNotification(_:)),
            name: NSNotification.Name("deleteDiary"),
            object: nil
        )
    }
    
    //MARK: - Method
    private func loadStarDiaryList() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
        diaryList = data.compactMap {
            guard let uuidString = $0["uuidString"] as? String else { return nil }
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            return Diary(uuidString: uuidString, title: title, contents: contents, date: date, isStar: isStar)
        } .filter {
            $0.isStar == true
        } .sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StarCell.self, forCellWithReuseIdentifier: "StarCell")
        view.addSubview(collectionView)
        
        // Add constraints for collectionView here
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        guard let index = self.diaryList.firstIndex(where: {
            $0.uuidString == diary.uuidString
        }) else { return }
        self.diaryList[index] = diary //row -> index
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
    
    @objc func starDiaryNotification(_ notification: Notification) {
        guard let starDiary = notification.object as? [String: Any] else { return }
        guard let diary = starDiary["diary"] as? Diary else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let uuidString = starDiary["uuidString"] as? String else { return }
        
        if isStar {
            diaryList.append(diary)
            collectionView.reloadData()
        } else if let uuidString = starDiary["uuidString"],
                  let index = diaryList.firstIndex(where: { $0.uuidString == uuidString as? String }) {
            diaryList.remove(at: index)
            collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    @objc func deleteDiaryNotification(_ notification: Notification) {
        guard let uuidString = notification.object as? String else { return }
        if let index = diaryList.firstIndex(where: { $0.uuidString == uuidString }) {
            diaryList.remove(at: index)
            collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        }
    }
}

//MARK: - Extension
extension StarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarCell", for: indexPath) as! StarCell
        
        let diary = diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = dateToString(date: diary.date)
        
        return cell
    }
}

extension StarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 80)
    }
}

extension StarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = DiaryDetailViewController()
        
        let diary = self.diaryList[indexPath.row]
//        viewController.diary = diary
//        viewController.indexPath = indexPath
        
//        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
