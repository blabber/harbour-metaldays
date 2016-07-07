// "THE BEER-WARE LICENSE" (Revision 42):
// <tobias.rehbein@web.de> wrote this file. As long as you retain this notice
// you can do whatever you want with this stuff. If we meet some day, and you
// think this stuff is worth it, you can buy me a beer in return.
//                                                             Tobias Rehbein

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
	allowedOrientations: Orientation.All

	property alias error: errorLabel.text

	SilicaFlickable {
		id: errorFlickable

		anchors.fill: parent
		contentHeight: column.height

		Column {
			id: column

			anchors {
				left: parent.left
				right: parent.right
				margins: Theme.horizontalPageMargin
			}

			PageHeader {
				title: 'Error'
				description: 'Something went wrong'
			}

			Label {
				id: errorLabel

				width: parent.width
				wrapMode: Text.Wrap
				color: Theme.highlightColor
			}
		}

		VerticalScrollDecorator { flickable: errorFlickable }
	}
}
