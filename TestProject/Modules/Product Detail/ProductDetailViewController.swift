//
//  ProductDetailViewController.swift
//  TestProject
//
//  Created by samarth on 16/02/21.
//

import UIKit
import SDWebImage

class ProductDetailViewController: UIViewController {

    @IBOutlet private weak var labelProductPrice: UILabel!
    @IBOutlet private weak var labelProductTitle: UILabel!
    @IBOutlet private weak var imageViewProduct: UIImageView!

    var productId: String?
    private var viewModel : ProductViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchProductDetail()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func fetchProductDetail(){
        self.viewModel = ProductViewModel(withProductId: self.productId)
        self.viewModel?.delegate = self
        self.viewModel?.getProductDetails()
    }
}

extension ProductDetailViewController : BaseViewModelDelegate  {
    func viewModelDidUpdate<T>(error: Error?, data: Any?, model: T.Type) {
        if model == ProductViewModel.self, error == nil, let tempData = data as? ProductLocal{
            self.labelProductTitle.text = tempData.title
            self.imageViewProduct.sd_setImage(with: URL(string: tempData.image ?? "")) { (image, error, type, url) in
                self.imageViewProduct.image = image
            }
            self.labelProductPrice.text = "₹ " + (tempData.price?.stringValue ?? "")
        } else {
        }
    }
    
    func viewModelDidUpdate(error: Error?) {
       
    }
}
