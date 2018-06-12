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
							var prevEndDate = "dummy";
							var startDate = "dummy";
							var endDate = "dummy";
							var nextStartDate = "dummy";

							var e = stage.events[i];
							if (e.timestamps != null) {
								startDate = new Date(e.timestamps.start * 1000);
								endDate = new Date(e.timestamps.end * 1000);

								prevEndDate = dayPage.dayStart;
								nextStartDate = endDate;

								if (i > 0) {
									var ne = stage.events[i-1];
									nextStartDate = new Date(ne.timestamps.start * 1000);
								}

								if (i < stage.events.length-1) {
									var pe = stage.events[i+1];
									prevEndDate= new Date(pe.timestamps.end * 1000);
								}
							}

							var item = {
								'time': e.time,
								'title': e.label,
								'url': e.url,
								'prevEndDate': prevEndDate,
								'startDate': startDate,
								'endDate': endDate,
								'nextStartDate': nextStartDate};

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

					Rectangle {
						width: Theme.paddingSmall
						color: Theme.secondaryHighlightColor

						visible: {
							if (nextStartDate == "dummy" || endDate == "dummy") {
								return false;
							}

							if (dayPage.now < nextStartDate && dayPage.now >= endDate) {
								return true;
							}

							return false;
						}

						anchors {
							top: parent.top
							bottom: innerListItem.top
							right: innerListItem.left
							rightMargin: Theme.paddingSmall
						}
					}

					Rectangle {
						width: Theme.paddingSmall
						color: Theme.secondaryHighlightColor

						visible: {
							if (startDate == "dummy" || endDate == "dummy") {
								return false;
							}

							if (dayPage.now >= startDate && dayPage.now < endDate) {
								return true;
							}

							return false;
						}

						anchors {
							top: innerListItem.top
							bottom: innerListItem.bottom
							right: innerListItem.left
							rightMargin: Theme.paddingSmall
						}
					}

					Rectangle {
						width: Theme.paddingSmall
						color: Theme.secondaryHighlightColor

						visible: {
							if (startDate == "dummy" || endDate == "dummy") {
								return false;
							}

							if (dayPage.now >= prevEndDate && dayPage.now < startDate) {
								return true;
							}

							return false;
						}

						anchors {
							top: innerListItem.bottom
							bottom: parent.bottom
							right: innerListItem.left
							rightMargin: Theme.paddingSmall
						}
					}

					Item {
						id: innerListItem
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
					}
				}

				VerticalScrollDecorator { flickable: eventsList }
			}
		}
	}
}
