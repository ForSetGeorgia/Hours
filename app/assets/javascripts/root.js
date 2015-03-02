$(function () {
    $('#daily-chart').highcharts({
        chart: {
            type: 'bar'
        },
        title: {
            text: ""
        },
        xAxis: {
            categories: ['']
        },
        yAxis: {
            min: 0,
            title: {
                text: "Today's Projects' Hours"
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