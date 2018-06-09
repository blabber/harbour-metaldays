// "THE BEER-WARE LICENSE" (Revision 42):
// <tobias.rehbein@web.de> wrote this file. As long as you retain this notice
// you can do whatever you want with this stuff. If we meet some day, and you
// think this stuff is worth it, you can buy me a beer in return.
//                                                             Tobias Rehbein

import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
	id: cover

	Image {
		id: coverImage
		source: "../../img/cover.png"
		fillMode: Image.PreserveAspectFit
		opacity: 0.125

		anchors {
			top: parent.top
			bottom: parent.verticalCenter
			left: parent.left
			right: parent.right
			margins: Theme.paddingSmall
		}
	}

	Label {
		id: coverLabel

		anchors {
			top: coverImage.bottom
			topMargin: Theme.paddingSmall
			horizontalCenter: coverImage.horizontalCenter
		}

		text: 'Metaldays'
		font.pixelSize: Theme.fontSizeLarge
		color: Theme.secondaryColor
	}

	BusyIndicator {
		id: indicator

		running: model.refreshing
		anchors {
			horizontalCenter: parent.horizontalCenter
			top: coverLabel.bottom
			bottomMargin: Theme.paddingSmall
		}

		NumberAnimation on rotation {
			from: 0; to: 360
			duration: 2000
			running: cover.status == Cover.Active && indicator.running
			loops: Animation.Infinite
		}
	}

	CoverActionList {
		CoverAction {
			iconSource: "image://theme/icon-cover-refresh"
			onTriggered: {
				for (var i = pageStack.depth; i > 0; i--) {
					pageStack.pop(null, PageStackAction.Immediate);
				}

				controller.startRefresh();
			}
		}
	}
}
