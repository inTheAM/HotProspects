//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Ahmed Mgua on 9/21/20.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
	@State private var isShowingScanner	=	false
	let filter:	FilterType
	var label:	String	{
		switch filter {
			case	.none:
				return	"Everyone"
			case	.contacted:
				return	"Contacted people"
			case	.uncontacted:
				return	"Uncontacted people"
		}
	}
	
	var filteredProspects:	[Prospect]	{
		switch filter {
			case	.none:
				return	prospects.people
			case	.contacted:
				return	prospects.people.filter	{	$0.isContacted	}
			case	.uncontacted:
				return	prospects.people.filter	{	!$0.isContacted	}
		}
	}
	
	@EnvironmentObject	var	prospects:	Prospects
	
	enum FilterType {
		case none,	contacted,	uncontacted
	}
	
	func handleScan(result:	Result<String,	CodeScannerView.ScanError>)	{
		self.isShowingScanner	=	false
		
		switch result {
			case .success(let code):
				let details	=	code.components(separatedBy:	"\n")
				guard details.count	==	2	else	{	return	}
				
				let person	=	Prospect()
				person.name	=	details[0]
				person.emailAddress	=	details[1]
				
				self.prospects.add(person)
				
				
			case	.failure:
				print("Scannning failed")
		}
	}
	
	func addNotification(for prospect:	Prospect)	{
		let center	=	UNUserNotificationCenter.current()
		
		let addRequest	=	{
			let content	=	UNMutableNotificationContent()
			content.title	=	"Contact \(prospect.name)"
			content.subtitle	=	prospect.emailAddress
			content.sound	=	UNNotificationSound.default
			
			var dateComponents	=	DateComponents()
			dateComponents.hour	=	9
			
			//			let trigger	=	UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
			let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
			let request	=	UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
			
			center.add(request)
		}
		
		center.getNotificationSettings	{	settings	in
			if settings.authorizationStatus	==	.authorized	{
				addRequest()
			}	else	{
				center.requestAuthorization(options: [.alert,	.sound,	.badge])	{	success,	error	in
					if success	{
						addRequest()
					}	else	{
						print("Unauthorized to notify at this time.")
					}
				}
			}
		}
	}
	
	var body: some View {
		NavigationView	{
			List	{
				ForEach(filteredProspects)	{	prospect	in
					HStack	{
						Group	{
							if prospect.isContacted	{
								Image(systemName: "checkmark.circle")
									.foregroundColor(.green)
								
								
							}	else	{
								Image(systemName: "circle")
									.foregroundColor(.red)
							}
							
						}.frame(width:10)
						
						VStack(alignment: .leading)	{
							Text(prospect.name)
								.font(.headline)
							Text(prospect.emailAddress)
								.foregroundColor(.secondary)
						}.contextMenu	{
							Button(prospect.isContacted	?	"Mark as uncontacted"	:	"Mark as contacted")	{
								self.prospects.toggle(prospect)
							}
							if !prospect.isContacted	{
								Button("Remind me")	{
									self.addNotification(for: prospect)
								}
							}
						}
					}
				}
			}
			.navigationBarTitle(label)
			.navigationBarItems(trailing: Button(action:	{
				self.isShowingScanner	=	true
				
			})	{
				Image(systemName: "qrcode.viewfinder")
				Text("Scan")
			})
			.sheet(isPresented: $isShowingScanner) {
				CodeScannerView(codeTypes:	[.qr],	simulatedData:	"Paul Hudson\npaul@hackingwithswift.com",	completion: self.handleScan)
			}
			
			
		}
	}
}

struct ProspectsView_Previews: PreviewProvider {
	static var previews: some View {
		ProspectsView(filter: .none)
	}
}
