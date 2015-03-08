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

  // start gathered at
  $("input#timestamp_start_at").datepicker({
    dateFormat: 'yy-mm-dd',
    onSelect: customRange
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
    onSelect: customRange
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
})