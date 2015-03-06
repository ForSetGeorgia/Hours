$(function () {
    $('#daily-chart').highcharts({
        chart: {
            type: 'bar'
        },
        title: {
            text: ""
        },
        xAxis: {
            categories: gon.dates
        },
        yAxis: {
            min: 0,
            title: {
                text: "Hours"
            }
        },
        legend: {
            reversed: true
        },
        plotOptions: {
            series: {
                stacking: 'normal'
            }
        },
        tooltip: {
            formatter: function () {
              return '<b>' + this.key + '</b><br/><span style="color:' + this.point.color + '">\u25CF</span> ' + this.series.name + ': <b>' + Highcharts.numberFormat(this.y,2) + ' hours</b><br/>';
            }
        },
        series: gon.projects
    });
});