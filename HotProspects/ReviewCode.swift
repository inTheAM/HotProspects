//
//  ReviewCode.swift
//  HotProspects
//
//  Created by Ahmed Mgua on 9/20/20.
//

import SwiftUI

struct ReviewCode: View {
	let user	=	User()
	@State private var selectedTab	=	0
	@ObservedObject	var	updater	=	DelayedUpdater()
	
	func fetchData(from urlString:	String,	completion:	@escaping	(Result<String,	NetworkError>)	->	Void)	{
		guard let url	=	URL(string: urlString)	else	{
			completion(.failure(.badURL))
			return
		}
		URLSession.shared.dataTask(with: url)	{	data,	response,	error	in
			DispatchQueue.main.async {
				if let data	=	data	{
					let stringData	=	String(decoding:	data,	as:	UTF8.self)
					completion(.success(stringData))
				}	else if	error	!=	nil	{
					completion(.failure(.requestFailed))
				}	else	{
					completion(.failure(.unknown))
				}
			}
		}.resume()
	}
	
	var body: some View {
		TabView(selection:	$selectedTab)	{
			VStack	{
				Text("Tab 1")
					.onTapGesture	{
						self.selectedTab	=	1
					}
				
			}
			.tabItem {
				Image(systemName: "triangle.fill")
				Text("One")
			}
			.tag(0)
			VStack	{
				EditView()
				DisplayView()
				Text("Value is: \(updater.value)")
				
				
			}
			.environmentObject(user)
			.onAppear	{
				self.fetchData(from: "https://www.apple.com")	{	result	in
					switch	result	{
						case	.success(let str):	print(str)
						case	.failure(let error):	switch	error	{
							case	.badURL:	print("Bad URL")
							case	.requestFailed:	print("Request failed")
							case	.unknown:	print("Unknown error")
						}
					}
				}
				
				
			}
			.tabItem {
				Image(systemName: "square.fill")
				Text("Two")
			}
			.tag(1)
			
			Image("example")
				.interpolation(.none)
				.resizable()
				.scaledToFit()
				.frame(maxHeight:	.infinity)
				.background(Color.black)
				.edgesIgnoringSafeArea(.all)
				.tabItem {
					Image(systemName: "circle.fill")
					Text("Three")
				}.tag(2)
		}
		
	}
}

class DelayedUpdater: ObservableObject {
	var value	=	0	{
		willSet	{
			objectWillChange.send()
		}
	}
	
	init()	{
		for i in 1...10	{
			DispatchQueue.main.asyncAfter(deadline: .now()	+	Double(i))	{
				self.value	+=	1
			}
		}
	}
}

class User:	ObservableObject	{
	@Published	var name	=	"Taylor Swift"
}

struct EditView:	View	{
	@EnvironmentObject	var user:	User
	
	var body: some View	{
		TextField("Name",	text:	$user.name)
	}
}
struct DisplayView:	View {
	@EnvironmentObject	var user:	User
	
	var body: some View	{
		Text(user.name)
	}
}

enum NetworkError:	Error {
	case badURL,	requestFailed,	unknown
}







struct ReviewCode_Previews: PreviewProvider {
	static var previews: some View {
		ReviewCode()
	}
}
