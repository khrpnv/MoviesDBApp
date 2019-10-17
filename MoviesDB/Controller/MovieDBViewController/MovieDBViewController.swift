//
//  MovieDBViewController.swift
//  MoviesDB
//
//  Created by student on 8/23/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import PopupDialog

class MovieDBViewController: UIViewController {
  
  @IBOutlet private weak var ibSegmentedControl: UISegmentedControl!
  @IBOutlet private weak var ibToolBar: UIToolbar!
  @IBOutlet private weak var ibSearchBar: UISearchBar!
  @IBOutlet private weak var tableView: UITableView!
  
  private var dataSource: [Film] = []
  private var filteredData: [Film] = []
  private var isSearchActive = false
  private var currentList: ListType = .popular
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupDelegates()
    styleUI()
    setupTableView()
    setupDataSource(movies: DataManager.instance.getFilmsArray(list: currentList))
    tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    tableView.reloadData()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    view.endEditing(true)
  }
  
  //MARK: - Private funcs
  private func styleUI(){
    self.title = "MoviesDB"
    navigationController?.navigationBar.hideBorderLine()
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.barStyle = .black
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    ibToolBar.barTintColor = .black
    ibSearchBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    let textFieldInsideSearchBar = ibSearchBar.value(forKey: "searchField") as? UITextField
    textFieldInsideSearchBar?.textColor = UIColor.white
    for subview in ibSearchBar.subviews[0].subviews {
      if subview is UITextField {
        subview.layer.borderWidth = 1.5
        subview.layer.borderColor = UIColor(red: 251/255, green: 140/255, blue: 0, alpha: 1).cgColor
        subview.layer.cornerRadius = 10
      }
    }
    addInfoButton()
  }
  
  private func setupDelegates(){
    tableView.delegate = self
    tableView.dataSource = self
    ibSearchBar.delegate = self
    ibToolBar.delegate = self
  }
  
  private func setupTableView(){
    let cellNib = UINib(nibName: "MovieTableViewCell", bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: "MovieCell")
  }
  
  private func setupDataSource(movies: [Film]){
    dataSource = movies
  }
  
  //MARK: - Search funcs
  private func filterContent(byName name: String){
    isSearchActive = !name.isEmpty
    filteredData.removeAll()
    for film in dataSource{
      if film.name.lowercased().contains(name.lowercased()){
        filteredData.append(film)
      }
    }
    tableView.reloadData()
  }
  
  private func getFilm(for indexPath: IndexPath) -> Film{
    return isSearchActive ? filteredData[indexPath.row] : dataSource[indexPath.row]
  }
  
  private func loadMoreData(){
    let networkManager = NetworkManager()
    networkManager.moviesViewControllerDelegate = self
    let pageCounter = DataManager.instance.getPageCounter(list: currentList)
    networkManager.getFilmData(requsetString: currentList.rawValue, listType: currentList, isInitial: false, page: pageCounter)
    DataManager.instance.setPageCounter(list: currentList)
  }
  
  private func scrollToFirstRow() {
    let indexPath = IndexPath(row: 0, section: 0)
    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
  }
  
  private func addInfoButton(){
    let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "infoButton"), style: .plain, target: self, action: #selector(showInfo))
    self.navigationItem.leftBarButtonItem = barButton
  }
  
  //MARK: - Action handlers
  @IBAction func didChooseSegment(_ sender: Any) {
    view.endEditing(true)
    if isSearchActive{
      return
    }
    switch ibSegmentedControl.selectedSegmentIndex {
    case 0:
      currentList = .popular
    case 1:
      currentList = .topRated
    case 2:
      currentList = .upcoming
    default:
      return
    }
    setupDataSource(movies: DataManager.instance.getFilmsArray(list: currentList))
    tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    scrollToFirstRow()
  }
  
  @objc private func showInfo(){
    
  }
  
}

//MARK: - UIToolBarDelegate
extension MovieDBViewController: UIToolbarDelegate{
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .top
  }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MovieDBViewController: UITableViewDelegate, UITableViewDataSource{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isSearchActive ? filteredData.count : dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell else {
      fatalError("Error: no such cell")
    }
    let film = getFilm(for: indexPath)
    cell.update(name: film.name, date: film.releaseDate, genreIds: film.genresId, imageURL: film.imageURL, averageVote: film.voteAverage)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let addFilmAction = UITableViewRowAction(style: .normal, title: "Add") { [weak self](action, indexPath) in
      guard let film = self?.getFilm(for: indexPath) else {
        fatalError("Erro: no such film")
      }
      tableView.reloadRows(at: [indexPath], with: .none)
    }
    addFilmAction.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.5490196078, blue: 0, alpha: 1)
    return [addFilmAction]
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return !(DataManager.instance.indexOf(film: getFilm(for: indexPath)) >= 0)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let film = getFilm(for: indexPath)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let lastSectionIndex = tableView.numberOfSections - 1
    let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
    if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex{
      let spinner = UIActivityIndicatorView(style: .white)
      spinner.startAnimating()
      spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
      self.tableView.tableFooterView = spinner
      self.tableView.tableFooterView?.isHidden = false
      loadMoreData()
    }
  }
}

//MARK: - UISearchBarDelegate
extension MovieDBViewController: UISearchBarDelegate{
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    filterContent(byName: searchText)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    view.endEditing(true)
  }
}

//MARK: - MoviesControllerDelegate
extension MovieDBViewController: MoviesControllerDelegate{
  func didFinishDownloading(array: [Film]) {
    tableView.tableFooterView?.isHidden = true
    tableView.tableFooterView = nil
    let startAmount = dataSource.count
    DataManager.instance.setDataArray(array: array, isInitial: false, list: currentList)
    setupDataSource(movies: DataManager.instance.getFilmsArray(list: currentList))
    var indexPathes: [IndexPath] = []
    let amountOfNewCells = dataSource.count - startAmount
    for i in 0..<amountOfNewCells{
      indexPathes.append(IndexPath(row: startAmount + i, section: 0))
    }
    let currentOffset = tableView.contentOffset.y
    if !isSearchActive{
      tableView.beginUpdates()
      tableView.insertRows(at: indexPathes, with: .automatic)
      tableView.endUpdates()
      tableView.setContentOffset(CGPoint(x: 0, y: currentOffset), animated: false)
    }
  }
}
