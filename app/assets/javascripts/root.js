$(function () {
    $('#daily-chart').highcharts({
        chart: {
            type: 'bar'
        },
        title: {
            text: "Today's Projects"
        },
        xAxis: {
            categories: ['']
        },
        yAxis: {
            min: 0,
            title: {
                text: 'Minutes'
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
        series: gon.projects
    });
});