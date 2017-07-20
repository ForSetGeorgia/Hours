$(function () {

  $('.bar-chart').each(function(index){
    $(this).highcharts({
      chart: {
          type: 'bar'
      },
      title: {
          text: gon.bar_chart_title[index]
      },
      subtitle: {
          text: gon.bar_chart_subtitle[index],
          useHTML: true,
          style: {'text-align': 'center', 'margin-top': '-15px'}
      },
      xAxis: {
          categories: gon.xaxis_categories
      },
      yAxis: {
          min: 0,
          title: {
              text: gon.bar_chart_xaxis
          }
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
      series: gon.chart_data[index]
    });
  });

  $('.pie-chart').each(function(index){
    $(this).highcharts({
      chart: {
          plotBackgroundColor: null,
          plotBorderWidth: null,
          plotShadow: false
      },
      title: {
          text: gon.pie_chart_title[index]
      },
      subtitle: {
          text: gon.bar_chart_subtitle[index],
          useHTML: true,
          style: {'text-align': 'center', 'margin-top': '-15px'}
      },
      tooltip: {
          pointFormat: '<b>{point.y} hours</b> ({point.percentage:.1f}%)'
      },
      plotOptions: {
          pie: {
              allowPointSelect: true,
              cursor: 'pointer',
              dataLabels: {
                  enabled: false
              },
              showInLegend: true
          }
      },
      series: [{
          type: 'pie',
          data: gon.chart_data[index]
      }]
    });
  });


//////////////////

  // $('#bar-chart').highcharts({
  //     chart: {
  //         type: 'bar'
  //     },
  //     title: {
  //         text: gon.bar_chart_title
  //     },
  //     subtitle: {
  //         text: gon.bar_chart_subtitle,
  //         useHTML: true,
  //         style: {'text-align': 'center', 'margin-top': '-15px'}
  //     },
  //     xAxis: {
  //         categories: gon.xaxis_categories
  //     },
  //     yAxis: {
  //         min: 0,
  //         title: {
  //             text: gon.bar_chart_xaxis
  //         }
  //     },
  //     plotOptions: {
  //         series: {
  //             stacking: 'normal'
  //         }
  //     },
  //     tooltip: {
  //         formatter: function () {
  //           return '<b>' + this.key + '</b><br/><span style="color:' + this.point.color + '">\u25CF</span> ' + this.series.name + ': <b>' + Highcharts.numberFormat(this.y,2) + ' hours</b><br/>';
  //         }
  //     },
  //     series: gon.chart_data
  // });

  // $('#pie-chart').highcharts({
  //   chart: {
  //       plotBackgroundColor: null,
  //       plotBorderWidth: null,
  //       plotShadow: false
  //   },
  //   title: {
  //       text: gon.pie_chart_title
  //   },
  //   subtitle: {
  //       text: gon.bar_chart_subtitle,
  //       useHTML: true,
  //       style: {'text-align': 'center', 'margin-top': '-15px'}
  //   },
  //   tooltip: {
  //       pointFormat: '<b>{point.y} hours</b> ({point.percentage:.1f}%)'
  //   },
  //   plotOptions: {
  //       pie: {
  //           allowPointSelect: true,
  //           cursor: 'pointer',
  //           dataLabels: {
  //               enabled: false
  //           },
  //           showInLegend: true
  //       }
  //   },
  //   series: [{
  //       type: 'pie',
  //       data: gon.chart_data
  //   }]
  // });


});