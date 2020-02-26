//
//  UIViewPreviews.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 2/26/20.
//  Copyright © 2020 zed. All rights reserved.
//


#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct PreviewRepresentable: UIViewRepresentable {
	
	let view: UIView
	
	
	func makeUIView(context: Context) -> UIView {
		return view
	}

	func updateUIView(_ uiView: UIView, context: Context) {
		
	}
	
}

@available(iOS 13.0, *)
struct UIViewPreviews: PreviewProvider {
	
	static var previews: some View {
		return PreviewRepresentable(view: UIView())
			.previewDevice(PreviewDevice(rawValue: "iPhone SE"))
	}
	
	
}

#endif

