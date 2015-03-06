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
            enabled: false
        },
        series: gon.projects
    });
});