//
//  ReviewCodeSecond.swift
//  HotProspects
//
//  Created by Ahmed Mgua on 9/20/20.
//

import SwiftUI
import UserNotifications


struct ReviewCodeSecond: View {
	@State private var backgroundColor	=	Color.red
    var body: some View {
		VStack	{
			Text("Whatever")
				.padding()
				.background(backgroundColor)
			
			Text("Change color")
				.padding()
				.contextMenu	{
					Button(action:	{
						self.backgroundColor	=	.red
					})	{
						Text("Red")
						Image(systemName: "checkmark.circle.fill")
							.foregroundColor(.red)
					}
					Button(action:	{
						self.backgroundColor	=	.green
					})	{
						Text("Green")
						Image(systemName: "checkmark.circle.fill")
							.foregroundColor(.green)
					}
					Button(action:	{
						self.backgroundColor	=	.blue
					})	{
						Text("Blue")
						Image(systemName: "checkmark.circle.fill")
							.foregroundColor(.blue)
					}
				}
			
			VStack	{
				Button("Request Permission")	{
					UNUserNotificationCenter.current().requestAuthorization(options: [.alert,	.badge,	.sound])	{	success,	error	in
						if success	{
							print("All set!")
						}	else	if	let	error	=	error	{
							print(error.localizedDescription)
						}
					}
				}.padding()
				Button("Schedule Notification")	{
					let content	=	UNMutableNotificationContent()
					content.title	=	"Feed the cat"
					content.subtitle	=	"It looks hungry"
					content.sound	=	UNNotificationSound.default
					
					let trigger	=	UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
					
					let request	=	UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
					
					UNUserNotificationCenter.current().add(request)
				}.padding()
			}
		}
    }
}

struct ReviewCodeSecond_Previews: PreviewProvider {
    static var previews: some View {
        ReviewCodeSecond()
    }
}
