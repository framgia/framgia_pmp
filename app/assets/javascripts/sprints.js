$(document).on('page:change', function() {
  $("#add-more-row").click(function(){

  });

  $("#add-more-column").click(function(){
    $("#sprints").animate({
      scrollLeft: $(".activities-panel").width()
    }, "fast");
  });

  $(".master-sprint-day").datepicker({
    format: I18n.t("date.day"),
    autoclose: true
  }).on("changeDate", function(event){
    var old_date = $(this).prev().val();
    var new_date = $(this).prev().val(event.format(I18n.t("date.js_format")));
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
      var m = next_date_new.getMonth() + 1;
      var y = next_date_new.getFullYear();
      $('.day-' + i).prev().val(y + '-' + m + '-' + d);
      $('.day-' + i).datepicker('update', new Date(y, m, d));
    }
  });
})
