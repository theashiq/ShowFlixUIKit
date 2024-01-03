//
//  ShowPreviewViewController.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/3/24.
//

import UIKit
import WebKit

class ShowPreviewViewController: UIViewController{
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
    
        configureConstraints()
    }
    
    func configureConstraints() {
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 450)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
    }
    
    func configure(with viewModel: PreviewViewModel){
        
        guard let url = viewModel.url else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    static func preview(for show: Show, from viewController: UIViewController){
        let searchQuery = "\(show.title) trailer"
        
        let previewVc = ShowPreviewViewController()
        
        DispatchQueue.main.async {
            viewController.navigationController?.pushViewController(previewVc, animated: true)
        }
        
        APICaller.shared.getPreviewMedia(for: searchQuery) { result in
            
            switch result{
                
            case .success(let previewMedia):
                DispatchQueue.main.async {
                    previewVc.configure(with: .get(from: previewMedia))
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
