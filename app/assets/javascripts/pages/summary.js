$(document).ready(function(){
  $('#' + gon.date_map_trigger_id).change(function() {
    get_date_map($(this).val())
  })
  var xhr = null
  var $start_at = $('input#timestamp_start_at')
  var $end_at = $('input#timestamp_end_at')

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
        }
        refresh_datepickers()
      }
     }
   });
  }
  function refresh_datepickers () {
    // return
    if (gon.start_at && gon.end_at){
      // start gathered at

      if (gon.start_at !== undefined && gon.start_at.length > 0)
      {
        $start_at.datepicker("setDate", new Date(gon.start_at));
      }
      if (gon.begin_at !== undefined && gon.begin_at.length > 0)
      {
        $start_at.datepicker('option', 'minDate', new Date(gon.begin_at));
      }
      if (gon.end_at !== undefined && gon.end_at.length > 0)
      {
        var end = new Date(gon.end_at);
        if (gon.last_at !== undefined && gon.last_at.length > 0){
          var last = new Date(gon.last_at);
          if (last < end){
            end = last;
          }
        }
        $start_at.datepicker('option', 'maxDate', end);
      }

      // end gathered at
      if (gon.end_at !== undefined && gon.end_at.length > 0)
      {
        $end_at.datepicker("setDate", new Date(gon.end_at));
        $end_at.datepicker('option', 'maxDate', new Date(gon.end_at));
      }
      if (gon.last_at !== undefined && gon.last_at.length > 0)
      {
        $end_at.datepicker('option', 'maxDate', new Date(gon.last_at));
      }
      if (gon.start_at !== undefined && gon.start_at.length > 0)
      {
        var start = new Date(gon.start_at);
        if (gon.begin_at !== undefined && gon.begin_at.length > 0){
          var begin = new Date(gon.begin_at);
          if (start < begin){
            start = begin;
          }
        }
        $end_at.datepicker('option', 'minDate', start);
      }
    }
  }
})
