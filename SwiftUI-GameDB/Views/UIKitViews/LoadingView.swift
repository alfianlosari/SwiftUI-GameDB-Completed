//
//  LoadingView.swift
//  SwiftUI-GameDB
//
//  Created by Alfian Losari on 09/08/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI

struct LoadingView: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<LoadingView>) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        return activityIndicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<LoadingView>) {
        uiView.startAnimating()
    }
}

