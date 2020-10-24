//
//  MeView.swift
//  HotProspects
//
//  Created by Ahmed Mgua on 9/21/20.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeView: View {
	@State private var name	=	"Test Name"
	@State private var emailAddress	=	"testemail@gmail.com"
	
	let context	=	CIContext()
	let filter	=	CIFilter.qrCodeGenerator()
	
	func generateQRCode(from string:	String)	->	UIImage	{
		let data	=	Data(string.utf8)
		filter.setValue(data, forKey: "inputMessage")
		
		if let outputImage	=	filter.outputImage	{
			if let cgimg	=	context.createCGImage(outputImage, from: outputImage.extent)	{
				return	UIImage(cgImage: cgimg)
			}
		}
		
		return	UIImage(systemName: "xmark.circle")	??	UIImage()
	}
	
    var body: some View {
		NavigationView	{
			VStack(alignment: .center)	{
				TextField("Name",	text:	$name)
					.textContentType(.name)
					.font(.title)
					.padding(.horizontal)
				
				TextField("Email address",	text:	$emailAddress)
					.textContentType(.emailAddress)
					.font(.title)
					.padding([.horizontal,	.bottom])
				
				Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
					.interpolation(.none)
					.resizable()
					.scaledToFit()
					.frame(width:	250,	height:	250)
				
				Spacer()
			}.navigationBarTitle("My code")
		}
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
