// "THE BEER-WARE LICENSE" (Revision 42):
// <tobias.rehbein@web.de> wrote this file. As long as you retain this notice
// you can do whatever you want with this stuff. If we meet some day, and you
// think this stuff is worth it, you can buy me a beer in return.
//                                                             Tobias Rehbein

import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
	id: cover

	Label {
		id: metaldaysLabel
		anchors.centerIn: parent
		text: 'Metaldays'
		color: Theme.secondaryColor
	}

	BusyIndicator {
		id: indicator

		running: model.refreshing
		anchors {
			horizontalCenter: parent.horizontalCenter
			bottom: metaldaysLabel.top
			bottomMargin: Theme.paddingSmall
		}

		NumberAnimation on rotation {
			from: 0; to: 360
			duration: 2000
			running: cover.status == Cover.Active && indicator.running
			loops: Animation.Infinite
		}
	}
}
