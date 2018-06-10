// "THE BEER-WARE LICENSE" (Revision 42):
// <tobias.rehbein@web.de> wrote this file. As long as you retain this notice
// you can do whatever you want with this stuff. If we meet some day, and you
// think this stuff is worth it, you can buy me a beer in return.
//                                                             Tobias Rehbein

function labelToDate(label) {
	var datePart = label.split(' ')[1];
	var day = datePart.split('.')[0]
	var month = datePart.split('.')[1] - 1;

	var year = (new Date()).getFullYear();

	return new Date(year, month, day);
}

function addTimeStringToDate(date, time) {
	var hours = time.split(':')[0];
	var minutes = time.split(':')[1];

	var t = date.getTime();
	t = t + (hours * 60 * 60 * 1000);
	t = t + (minutes * 60 * 1000);
	if (hours < 10) {
		t = t + (24 * 60 * 60 * 1000);
	}

	return new Date(t);
}
