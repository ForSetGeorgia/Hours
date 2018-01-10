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
//= require_directory .

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
      dom: '<"dataTables_row"lT><"dataTables_row"<"dataTables_filters">f>rtip',
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
    if ($('table:not(.no-datatable) thead th[data-filter="only-active"]').length > 0) {
      $('.dataTables_filters').html('<input type="checkbox" id="dataTablesFilterOnlyActive"/><label for="dataTablesFilterOnlyActive">' + gon.label_active + '</label>')
      var dt = $('table').DataTable();
      $('#dataTablesFilterOnlyActive').change(function () {
        dt
          .columns('[data-filter="only-active"]')
          .search(this.checked ? 'yes' : '')
          .draw()
      })
      $('#dataTablesFilterOnlyActive').attr('checked', 'checked').trigger('change');
    }

  }

  // assign chosen to all selects
  if ($('select').length > 0){
    $('select').chosen({width: '100%', display_disabled_options: false, display_selected_options: false});
    if ($('.assignee-selector').length > 0){
      $('.assignee-selector').on('change', function (evt, params) {
        var state = true // true - selected , false - deselected
        var id = null
        if (params.hasOwnProperty('selected')) {
          id = params.selected;
        } else if (params.hasOwnProperty('deselected')) {
          state = false;
          id = params.deselected;
        }
        if(id === '0') {
          $('.assignee-selector option:not([value="0"])').attr('disabled', state);
          $('.assignee-selector').trigger("chosen:updated");
        }
      })
    }
    /*
    if ($('#timestmap_activity_id').length > 0){
      var your_id = $('#timestmap_activity_id').attr('data-your-id');

      $('#timestmap_activity_id').on('change', function (evt, params) {
        // console.log('test2')
        // console.log(params)
        var state = true // true - selected , false - deselected
        var id = null
        if (params.hasOwnProperty('selected')) {
          id = params.selected;
        } else if (params.hasOwnProperty('deselected')) {
          state = false;
          id = params.deselected;
        }

        var manager_id = $('#timestmap_activity_id option[value="' + id + '"]').parent().attr('data-manager');

        // console.log(manager_id, your_id, manager_id === your_id)
        $('.assignee-selector option:selected').removeAttr('selected');
        $('.assignee-selector option').attr('disabled', manager_id !== your_id);
        $('.assignee-selector').trigger("chosen:updated");
      })
      // console.log('test')
      var activity_id = +$('#timestmap_activity_id').val();
      if(activity_id > 0) {
        var manager_id = $('#timestmap_activity_id option[value="' + activity_id + '"]').parent().attr('data-manager');
        $('.assignee-selector option').attr('disabled', manager_id !== your_id);
        $('.assignee-selector').trigger("chosen:updated");
      }
    }
    */
  }

  if($('#active_projects_checkbox').length > 0) {
    $('#active_projects_checkbox').change(function() {
      $('#active_projects_value').val(this.checked);
    })
  }
  if($('#active_projects_checkbox_filter').length > 0) {
    $('#active_projects_checkbox_filter').change(function() {
      $('#timestamp_project_id option[data-active=false]').attr('disabled', this.checked);
      $('#timestamp_project_id').trigger("chosen:updated");
    })
  }

  if($('#active_users_checkbox').length > 0) {
    $('#active_users_checkbox').change(function() {
      $('#active_users_value').val(this.checked);
    })
  }
  if($('#active_users_checkbox_filter').length > 0) {
    $('#active_users_checkbox_filter').change(function() {
      $('#timestamp_user_id option[data-active=false]').attr('disabled', this.checked);
      $('#timestamp_user_id').trigger("chosen:updated");
    })
  }


});
