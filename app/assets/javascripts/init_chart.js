var chart;
var estimate_data = [0];
var actual_data = [0];

$(document).on("page:change", function (){
  var burndown_chart = $("#burndown_chart");
  if (burndown_chart.length > 0){
    getChartData();
    initChart();
  }
});

function getChartData() {
  for(var i = 0; i < 10; i++) {
    actual_data[i + 1] = parseInt($(".log-actual-" + i).text());
    estimate_data[i + 1] = parseInt($(".log-estimate-" + i).text());
  }
}
$(document).on("change click", "td input", function(){
  getChartData();
  chart.series[0].update({
    data: actual_data
  });

  chart.series[1].update({
    data: estimate_data
  });
});
function initChart(){
  chart = new Highcharts.Chart({
    chart: {
      renderTo: "burndown_chart",
      height: 300,
      width: $(window).outerWidth() - $('#tracking-time').outerWidth() - 30
    },
    title: {
      text: "Burndown Chart"
    },
    colors: ["#BF0622", "#5559D6"],
    xAxis: {
      min: 1,
      title: {text: "Working days"}
    },
    yAxis: {
      title: {text: "Estimate time"},
      lineWidth: 1
    },
    credits: {
      enabled: false
    },
    tooltip: {
      shared: true,
      useHTML: true,
      hideDelay: 10,
      borderColor: "#7cb5ec",
      headerFormat: "<div style='text-align: center'>Day" + ": <b>{point.key}</b></div>",
      valueSuffix: " (h)",

    },
    legend: {
      align: "right",
      layout: "vertical"
    },
    series: [{
      name:"Actual",
      data: actual_data
      }]
  });

  chart.addSeries({
    name: "Estimate",
    data: estimate_data
  });
}
