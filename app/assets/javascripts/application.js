
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
//= require i18n
//= require i18n/translations
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.ja.js
//= require bootstrap-datepicker/locales/bootstrap-datepicker.en-GB.js
//= require select2
//= require dhtmlx/dhtmlx_core
//= require dhtmlx/dhtmlxspreadsheet
//= require dhtmlx/dhtmlxgrid_borderselection
//= require dhtmlx/dhtmlxgrid_shcell
//= require dhtmlx/dhtmlxsh_buffer
//= require dhtmlx/dhtmlxsh_config
//= require dhtmlx/dhtmlxsh_context
//= require dhtmlx/dhtmlxsh_css
//= require dhtmlx/dhtmlxsh_export
//= require dhtmlx/dhtmlxsh_headedit
//= require dhtmlx/dhtmlxsh_keys
//= require dhtmlx/dhtmlxsh_loader
//= require dhtmlx/dhtmlxsh_mathhint
//= require dhtmlx/dhtmlxsh_modal
//= require dhtmlx/dhtmlxsh_selection
//= require dhtmlx/dhtmlxsh_undo
//= require spreadsheet
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
});
