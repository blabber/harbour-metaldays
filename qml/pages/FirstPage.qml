// "THE BEER-WARE LICENSE" (Revision 42):
// <tobias.rehbein@web.de> wrote this file. As long as you retain this notice
// you can do whatever you want with this stuff. If we meet some day, and you
// think this stuff is worth it, you can buy me a beer in return.
//                                                             Tobias Rehbein

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
	id: firstPage

	allowedOrientations: Orientation.All

	Column {
		anchors.centerIn: parent
		width: parent.width

		spacing: Theme.paddingMedium
		visible: model.refreshing

		ProgressBar {
			anchors {
				left: parent.left
				right: parent.right
				margins: Theme.horizontalPageMargin
			}

			indeterminate: true
		}

		Label {
			anchors.horizontalCenter: parent.horizontalCenter
			text: "Refreshing…"
			color: Theme.secondaryHighlightColor
		}
	}

	SilicaListView {
		id: daysList

		Component.onCompleted: {
			firstPage.populateList();
		}

		anchors.fill: parent

		PullDownMenu {
			MenuItem {
				text: 'Refresh'
				onClicked: controller.startRefresh()
				enabled: !model.refreshing
			}

			busy: model.refreshing
		}

		header: PageHeader {
			width: parent.width
			title: 'Running Order'
		}

		model: ListModel { id: daysListModel }

		delegate: ListItem {
			id: listItem

			contentHeight: Theme.itemSizeMedium

			Column {
				width: parent.width

				anchors {
					verticalCenter: parent.verticalCenter
					left: parent.left
					leftMargin: Theme.horizontalPageMargin
				}

				Label {
					text: day
					color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
				}

				Label {
					text: date
					color: listItem.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
					font.pixelSize: Theme.fontSizeSmall
				}
			}

			onClicked: pageStack.push('DayPage.qml', {'dayIndex': index})
		}

		ViewPlaceholder {
			enabled: daysList.count == 0 && !model.refreshing
			text: "No data loaded"
			hintText: "Pull down to refresh data"
		}

		VerticalScrollDecorator { flickable: daysList }
	}

	Connections {
		target: model

		onRefreshingChanged: {
			if (model.refreshing) {
				daysListModel.clear();
			} else {
				firstPage.populateList();
			}
		}
	}

	function populateList() {
		if (model.data['days']) {
			model.data['days'].forEach(function(e, i, a) {
				daysListModel.append({'index': i, 'day': 'Day ' + (i+1), 'date': e['label']});
			});
		}
	}
}
