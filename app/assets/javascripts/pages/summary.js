$(document).ready(function(){
  $('#' + gon.date_map_trigger_id).change(function() {
    get_date_map($(this).val())
  })
  var xhr = null
  var $start_at = $('input#timestamp_start_at')
  var $end_at = $('input#timestamp_end_at')

  function padZero(n) { return n < 10 ? '0' + n : n; }

  function get_date_map(id) {
   if( xhr != null ) {
     xhr.abort();
     xhr = null;
   }

   /* and now we can safely make another ajax request since the previous one is aborted */
   xhr = $.ajax({
     type: "GET",
     url: gon.date_map_url.replace('__id__', id),
     dataType: 'json',
     success: function(dates) {
      gon.datepicker_dates = dates
      if (dates.length) {
        gon.datepicker_dates = dates
        gon.begin_at = dates[0]
        if(dates.length > 1) {
          gon.last_at = dates[dates.length-1]
        } else {
          gon.last_at = dates[0]
        }
        refresh_datepickers()
      }
     }
   });
  }
  function refresh_datepickers () {
    $start_at.datepicker('option', {
      minDate: new Date(gon.begin_at),
      maxDate: new Date(gon.last_at)
    });
    $start_at.datepicker('setDate', new Date(gon.begin_at))
    $end_at.datepicker('option', {
      minDate: new Date(gon.begin_at),
      maxDate: new Date(gon.last_at)
    });
    $end_at.datepicker('setDate', new Date(gon.last_at))
  }
})
