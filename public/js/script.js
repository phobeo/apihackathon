/* Author:

*/

$(document).ready(function() {
  setupPlugins();
  addHomeMap();
  addCharts();
});

function setupPlugins() {
	$('.dropdown-toggle').dropdown();
}

function addHomeMap() {
	$('#homemap').gmap().bind('init', function(ev, map) {
		$('#homemap').gmap('addMarker', {'position': '57.7973333,12.0502107', 'bounds': true}).click(function() {
			$('#homemap').gmap('openInfoWindow', {'content': 'site1'}, this);
		});
		$('#homemap').gmap('addMarker', {'position': '57.8073333,12.0802107', 'bounds': true}).click(function() {
			$('#homemap').gmap('openInfoWindow', {'content': 'site 2'}, this);
		});
	});
}

function addCharts() {
	var data = new google.visualization.DataTable();
	        data.addColumn('string', 'Type');
	        data.addColumn('number', 'Number');
	        data.addRows([
	          ['Car (gas)', 1],
	          ['Car (diesel)', 27],
	          ['Car (hybrid)', 2],
	          ['Motorbike', 2],
	          ['HDV (large)', 47]
	        ]);
	        var options1 = {'legend':'bottom',
			  'is3D':true,};
	        var chart1 = new google.visualization.PieChart(document.getElementById('type_chart'));
	        chart1.draw(data, options1);
	
			var options2 = {'legend':'bottom',
			  'is3D':false,};
			var chart2 = new google.visualization.PieChart(document.getElementById('euro_chart'));
	        chart2.draw(data, options2);
}


