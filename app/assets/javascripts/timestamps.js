$(function() {
  // when start/end date changes, set the max/min date of the opposite date
  function customRange(dates) {
    if (this.id == 'timestamp_start_at') {
      $('input#timestamp_end_at').datepicker('option', 'minDate', dates || null);
    }
    else {
      $('input#timestamp_start_at').datepicker('option', 'maxDate', dates || null);
    }
  }

  // make only days with timestamps active
  function highlightDays(date) {
    var clone_date = new Date(date.getTime());
    clone_date.setHours(clone_date.getHours()+4);
    if (gon.datepicker_dates){
      if ($.inArray(date.toISOString().slice(0,10), gon.datepicker_dates) > -1){
        return [true, 'datepicker-highlight'];
      }
    }
    return [false, ''];
   }

  // used on timestamp index page
  if (gon.timestamp_date){
    // todays date for timestmap form
    $("input#timestamp_date").datepicker({
      dateFormat: 'yy-mm-dd'
    });
    if (gon.timestamp_date !== undefined && gon.timestamp_date.length > 0)
    {
      var date = new Date(gon.timestamp_date);
      $("input#timestamp_date").datepicker("setDate", date);
      $('input#timestamp_date').datepicker('option', 'maxDate', date);
      var minDate = new Date(new Date().setDate(date.getDate()-7));
      $('input#timestamp_date').datepicker('option', 'minDate', minDate);
    }
  }

  // used in summary date page
  if (gon.timestamp_summary_date){
    $("input#timestamp_date").datepicker({
      dateFormat: 'yy-mm-dd',
      beforeShowDay: highlightDays
    });
    if (gon.timestamp_summary_date !== undefined && gon.timestamp_summary_date.length > 0)
    {
      var date = new Date(gon.timestamp_summary_date);
      $("input#timestamp_date").datepicker("setDate", date);
      if (gon.last_at !== undefined && gon.last_at.length > 0){
        $('input#timestamp_start_at').datepicker('option', 'maxDate', new Date(gon.last_at));
      }
      if (gon.begin_at !== undefined && gon.begin_at.length > 0){
        $('input#timestamp_end_at').datepicker('option', 'minDate', new Date(gon.begin_at));
      }
    }
  }

  // used in summary user/project page
  if (gon.start_at && gon.end_at){
    // start gathered at
    $("input#timestamp_start_at").datepicker({
      dateFormat: 'yy-mm-dd',
      onSelect: customRange,
      beforeShowDay: highlightDays
    });
    if (gon.start_at !== undefined && gon.start_at.length > 0)
    {
      $("input#timestamp_start_at").datepicker("setDate", new Date(gon.start_at));
    }
    if (gon.begin_at !== undefined && gon.begin_at.length > 0)
    {
      $('input#timestamp_start_at').datepicker('option', 'minDate', new Date(gon.begin_at));
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
      $('input#timestamp_start_at').datepicker('option', 'maxDate', end);
    }

    // end gathered at
    $("input#timestamp_end_at").datepicker({
      dateFormat: 'yy-mm-dd',
      onSelect: customRange,
      beforeShowDay: highlightDays
    });
    if (gon.end_at !== undefined && gon.end_at.length > 0)
    {
      $("input#timestamp_end_at").datepicker("setDate", new Date(gon.end_at));
      $('input#timestamp_end_at').datepicker('option', 'maxDate', new Date(gon.end_at));
    }
    if (gon.last_at !== undefined && gon.last_at.length > 0)
    {
      $('input#timestamp_end_at').datepicker('option', 'maxDate', new Date(gon.last_at));
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
      $('input#timestamp_end_at').datepicker('option', 'minDate', start);
    }
  }

  // when all day selected, enter 7 hours into the duration box
  $('.btn-all-day').click(function(){
    $('input#timestamp_duration').val(420);
  });
})