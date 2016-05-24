
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require product_backlog
//= require_tree .
//= require i18n
//= require i18n/translations
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.ja.js
//= require bootstrap-datepicker/locales/bootstrap-datepicker.en-GB.js
//= require select2
//= require dhtmlxcommon
//= require dhtmlxgrid
//= require dhtmlxgridcell
//= require dhtmlxdataprocessor

$(document).on("page:change", function(){
  $(".datepicker").datepicker({
    format: I18n.t("date.format")
  });

  $( "#assignee" ).select2({
    multiple: true,
    theme: "bootstrap",
    width: '100%'
  });

  $('#add-col').click(function(){
    var count_col = $('#lost_hour_table').data("countCol");
    var count_day = $('#lost_hour_table tr:first th').length;
    var temp = count_col - 1
    $('#activities').find('tr').each(function(value){
      switch(value) {
        case 0:
          $(this).find('th:last').after('<th class="panel-left">'+ count_day +'</th>');
          break;
        case 1:
          $(this).find('th:last').after('<th class="panel-left log-actual-'
            + count_col +'"></th>');
          break;
        case 2:
          $(this).find('th:last').after('<th class="panel-left log-estimate-'
            + count_col +'">'+ $(this).find('th:last').html() +'</th>');
          break;
      }
      var val_pre = $(this).find('td:last input').val();
      $(this).find('td').last().after('<td class="panel-left"><input type="number"'
        +'class="log log-' + temp +' row-'+ count_col +'" value="'+ val_pre +'"></td>');
    });
    $('#lost_hour_table').find('tr').each(function(value){
      var html = '';
      html += '<td><input type="number" name="sprint[time_logs_attributes][';
      html += count_col;
      html += '][lost_hour]"></td>';
      $(this).find('th').last().after('<th></th>');
      $(this).find('td').last().after(html);
    });
    $('#lost_hour_table').data("countCol", count_col + 1);
  });
});
