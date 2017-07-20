// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require i18n
//= require i18n/translations
//= require jquery
//= require jquery_ujs
//= require jquery-ui/core
//= require jquery-ui/effect
//= require jquery-ui/datepicker
//= require twitter/bootstrap
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require dataTables/extras/dataTables.tableTools
//= require highcharts
//= require chosen-jquery
//= require jquery_nested_form
//= require vendor
//= require_tree .

$(document).ready(function(){
	// set focus to first text box on page
	if (gon.highlight_first_form_field){
	  $(":input:visible:enabled:first").focus();
	}

	// workaround to get logout link in navbar to work
	$('body')
		.off('click.dropdown touchstart.dropdown.data-api', '.dropdown')
		.on('click.dropdown touchstart.dropdown.data-api', '.dropdown form', function (e) { e.stopPropagation() });

  // assign datatable to all tables
  if ($('table:not(.no-datatable)').length > 0){
    $('table').dataTable({
      dom: 'T<"clear">lfrtip',
      tableTools: {
        "sSwfPath": "/assets/dataTables/extras/swf/copy_csv_xls_pdf.swf",
        "aButtons": [
          {
            "sExtends": "csv",
            "mColumns": [ 0,1,2,3,4,5 ]
          },
          {
            "sExtends": "xls",
            "mColumns": [ 0,1,2,3,4,5 ]
          }
        ]
      }
    });
  }

  // assign chosen to all selects
  if ($('select').length > 0){
    $('select').chosen({width: '100%'});
  }
});
