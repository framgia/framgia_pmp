$(document).on('page:change', function() {
  setSprintHeight();

  $(window).resize(function() {
    setSprintHeight();
  });

  function setSprintHeight() {
    $("#sprints").outerHeight($(window).height() - $("header").outerHeight() - $("#category-tab").outerHeight() - 4);
  }

  masterSprintDateListener = function() {
    if(new Date($(this).val()).toDateString() == new Date().toDateString()) {
      $(".today").removeClass("today");
      $(this).closest("td").addClass("today");
      setColorToday();
    } else if($(this).closest("td").hasClass("today")) {
      $(".today").removeClass("today");
    }
  }

  changeDateListener = function(event) {
    var old_date = $(this).prev().val();
    var new_date = $(this).prev().val(event.format(I18n.t("date.js_format"))).change();
    var changeDate = new Date(new_date.val()).getTime() - new Date(old_date).getTime();
    var filterRow = function(v) {return v.indexOf('day-') == 0};
    var colClass = this.className.split(' ').filter(filterRow)[0];
    var cells = $('input[class*="master-sprint-day"]');
    var i = parseInt(colClass.split('-')[1]) + 1;
    for(i; i <= cells.length; i++ ) {
      var next_date = $(".day-" + i).prev().val();
      var tmp = new Date(next_date);
      var next_date_new = new Date(tmp.getTime() + changeDate);
      var d = next_date_new.getDate();
      var m = next_date_new.getMonth();
      var y = next_date_new.getFullYear();
      $('.day-' + i).prev().val(y + '-' + (m  + 1) + '-' + d).change();
      $('.day-' + i).datepicker('update', new Date(y, m, d));
    }
  }

  $(".master-sprint-day").datepicker({
    format: I18n.t("date.js_format"),
    autoclose: true
  }).on("changeDate", changeDateListener);

  $(".master-sprint-date").change(masterSprintDateListener);
})
