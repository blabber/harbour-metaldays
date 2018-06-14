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
	property date dayStart: new Date(day.timestamps.start * 1000)
	property date now: model.now

	PageHeader {
		id: pageHeader
		width: parent.width
		title: 'Day ' + (dayIndex + 1)
		description: day['label']
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
			property var stage: day['stages'][index]

			width: slideShowView.itemWidth
			height: slideShowView.itemHeight

			SectionHeader {
				id: stageHeader
				text: stage['label']
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
						for (var i = 0; i < stage.events.length; i++)
						{
							var startDate = "dummy";
							var endDate = "dummy";

							var e = stage.events[i];
							if (e.timestamps != null) {
								startDate = new Date(e.timestamps.start * 1000);
								endDate = new Date(e.timestamps.end * 1000);
							}

							var item = {
								'time': e.time,
								'title': e.label,
								'url': e.url,
								'startDate': startDate,
								'endDate': endDate};

							append(item);
						}
					}
				}

				delegate: ListItem {
					id: listItem

					contentHeight: Theme.itemSizeSmall
					width: ListView.view.width
					enabled: url != '#'
					onClicked: Qt.openUrlExternally(url);

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
							anchors.left: parent.left
							text: time
							color: !listItem.enabled || listItem.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
							font.weight: dayPage.now >= startDate && dayPage.now < endDate ? Font.Bold : Font.Normal
							font.strikeout: dayPage.now > endDate
						}

						Label {
							id: titleLabel
							text: title
							truncationMode: TruncationMode.Fade
							color: !listItem.enabled || listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
							font.weight: dayPage.now >= startDate && dayPage.now < endDate ? Font.Bold : Font.Normal

							anchors {
								left: timeLabel.right
								leftMargin: Theme.paddingLarge
								right: parent.right
							}
						}
					}
				}

				VerticalScrollDecorator { flickable: eventsList }
			}
		}
	}
}
