// "THE BEER-WARE LICENSE" (Revision 42):
// <tobias.rehbein@web.de> wrote this file. As long as you retain this notice
// you can do whatever you want with this stuff. If we meet some day, and you
// think this stuff is worth it, you can buy me a beer in return.
//                                                             Tobias Rehbein

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
	id: dayPage
	allowedOrientations: Orientation.All

	property int dayIndex
	property var day: model.data['days'][dayIndex]

	PageHeader {
		id: pageHeader
		width: parent.width
		title: 'Day ' + (dayIndex + 1)
		description: day['date']
	}

	SlideshowView {
		anchors {
			left: parent.left
			right: parent.right
			top: pageHeader.bottom
			bottom: parent.bottom
		}

		clip: true

		id: slideShowView

		itemWidth: width
		itemHeight: height

		model: dayPage.day['stages'].length

		delegate: Item {
			width: slideShowView.itemWidth
			height: slideShowView.itemHeight

			SectionHeader {
				id: stageHeader
				text: day['stages'][index]['name']
			}

			SilicaListView {
				id: eventsList

				anchors {
					top: stageHeader.bottom
					bottom: parent.bottom
				}
				width: parent.width
				clip: true

				model: ListModel {
					Component.onCompleted: {
						var events = dayPage.day['stages'][index]['events'];
						events.forEach(function (e, i, a) {
							append({ 'time': e['time'], 'title': e['title'], 'genre': e['genre'], 'url': e['url'] });
						});
					}
				}

				delegate: ListItem {
					id: listItem

					contentHeight: Theme.itemSizeMedium
					width: ListView.view.width
					enabled: url != '#'

					onClicked: pageStack.push('WebViewPage.qml', { 'url': url });

					menu: ContextMenu {
						MenuItem {
							text: 'Open in external browser'
							onClicked: Qt.openUrlExternally(url);
						}
					}

					Item {
						height: childrenRect.height

						anchors {
							left: parent.left
							right: parent.right
							margins: Theme.horizontalPageMargin
							verticalCenter: parent.verticalCenter
						}

						Label {
							id: timeLabel

							anchors { left: parent.left }

							text: time
							color: !listItem.enabled || listItem.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
						}

						Label {
							id: titleLabel

							anchors {
								left: timeLabel.right
								leftMargin: Theme.paddingMedium
								right: parent.right
							}

							text: title
							truncationMode: TruncationMode.Fade
							color: !listItem.enabled || listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
						}

						Label {
							anchors {
								left: timeLabel.right
								leftMargin: Theme.paddingMedium
								right: parent.right
								top: titleLabel.bottom
							}

							text: genre
							font.pixelSize: Theme.fontSizeSmall
							truncationMode: TruncationMode.Fade
							color: !listItem.enabled || listItem.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
						}
					}
				}

				VerticalScrollDecorator { flickable: eventsList }
			}
		}
	}
}
