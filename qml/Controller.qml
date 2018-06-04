// "THE BEER-WARE LICENSE" (Revision 42):
// <tobias.rehbein@web.de> wrote this file. As long as you retain this notice
// you can do whatever you want with this stuff. If we meet some day, and you
// think this stuff is worth it, you can buy me a beer in return.
//                                                             Tobias Rehbein

import QtQuick 2.0
import io.thp.pyotherside 1.4

Python {
	Component.onCompleted: {
		addImportPath(Qt.resolvedUrl('../python'));

		setHandler('dataLoaded', function(newvalue) {
			model.data = newvalue.data;
			model.refreshing = false;
		});

		setHandler('refreshError', function(error) {
			model.refreshing = false
			pageStack.push('pages/ErrorPage.qml', { 'error': error })
		});

		importModule('controller', function () {})
	}

	function startRefresh() {
		model.progressLabel = "Refreshing..."
		model.progressValue = 0
		model.progressMaxValue = 0

		model.refreshing = true;
		call('controller.instance.refresh', function() {});
	}

	onError: {
		console.log('python error: ' + traceback);
	}

	onReceived: {
		console.log('got message from python: ' + data);
	}
}
