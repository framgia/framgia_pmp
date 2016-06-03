$(document).on('page:change', function(){
  $('[data-toggle="tooltip"]').tooltip();
  // total log_works
  totalLogWorksCol = function() {
    $.each($('th[class*="log-estimate"]'), function(i, col) {
      var filter = function(v) {return v.indexOf('log-estimate') == 0}
      var className = col.className.split(' ').filter(filter)[0];
      if(className.split('-').pop() == '0') return;
      $(col).text(totalColumnValue('log-' + className.split('-').pop()));
    });
  }

  // total time remaining
  function timeRemain() {
    $.each($('.log-0'), function(i, cell) {
      var filter = function(v) {return v.indexOf('row') == 0}
      var className = cell.className.split(' ').filter(filter)[0];
      setRemainTime(className);
    });
    $('.remaining-header').text(totalColumnValue('remaining') + '');
    worked();
  }

  function totalColumnValue(col) {
    var cells = $('#activities .' + col);
    var total = 0;
    $.each(cells, function(i, e) {
      var val = parseInt($(e).val());
      total += isNaN(val) ? 0 : val;
    });
    return total;
  }

  setActual = function(col) {
    var workHour = parseInt($("#work-hour-0" + " input").val());

    var cells = $('th[class*="log-actual"]');
    for(col; col < cells.length; col++) {
      var lostHour = parseInt($("#lost-hour-" + col + " input").val());
      $(cells[col]).text(parseInt($(cells[col - 1]).text()) + lostHour - workHour);
    }
  }

  function worked() {
    var estimated = parseInt($('.log-estimate-1').text());
    var remaining = parseInt($('.remaining-header').text());
    var worked = estimated - remaining;
    var worked_percent = Math.round(worked/estimated*100);
    $('.worked').text(worked);
    $('.worked-percent').text(worked_percent + '%');
    $('.remaining-percent').text((100 - worked_percent) + '%');
  }

  function setRemainTime(row) {
    var cells = $('.' + row);
    $('.remaining.' + row).val(cells.last().val()).change();
    $('.remaining-header').text(totalColumnValue('remaining') + '');
    worked();
  }

  function setRowColor(rowClass) {
    var assigneeValue = $('.assignee.' + rowClass).val();
    var remainingValue = $('.remaining.' + rowClass).val();
    var estimateValue = $('.log-1.' + rowClass).val();

    var row = $('.' + rowClass).closest('tr');

    // assignee is empty
    if(assigneeValue == '') {
      if(estimateValue != '0') {
        if(remainingValue != '0') {
          row.addClass('estimated');
          row.removeClass('assigned default processed');
        } else {
          row.addClass('default');
          row.removeClass('assigned estimated processed');
        }
      }
      else {
        row.removeClass('estimated assigned processed');
        row.addClass('default');
      }
    } else {
      if(estimateValue != '0') {
        if(remainingValue != '0') {
          row.removeClass('assigned default estimated');
          row.addClass('processed');
        } else {
          row.removeClass('assigned processed estimated');
          row.addClass('default');
        }
      }
      else {
        row.removeClass('processed default estimated');
        row.addClass('assigned');
      }
    }
  }

  setColorToday = function() {
    if ($("#activities").length > 0) {
      today_column = $(".today");
      activity_column_index = today_column.index() / 2 + 5;
      header_index = activity_column_index - 3;
      $('#activities tr td:nth-child(' + activity_column_index + ')').css("background-color", "#F00");
      $('#activities .master-sprint-working-day th:nth-child(' + activity_column_index + ')').css("background-color", "#F00");
      $('#activities .master-estimate-plan th:nth-child(' + header_index + '), .actual th:nth-child(' + header_index + ')').css("background-color", "#F00");
      today_column.css("background-color", "#F00");
    }
  }

  logWorkEventListener = function() {
    var filterRow = function(v) {return v.indexOf('row-') == 0}
    var rowClass = this.className.split(' ').filter(filterRow)[0];

    var filterLog = function(v) {return v.indexOf('log-') == 0}
    var logClass = this.className.split(' ').filter(filterLog)[0];

    var cells = $('.panel-left .' + rowClass);
    var i = parseInt(logClass.split('-')[1]);
    for(i; i < cells.length; i++) {
      $(cells[i]).val($(this).val());
    }

    totalLogWorksCol();
    setRemainTime(rowClass);
  }

  estimateEventListener = function() {
    var self = this;
    var filterRow = function(v) {return v.indexOf('row-') == 0}
    var rowClass = this.className.split(' ').filter(filterRow)[0];
    var cells = $('.panel-left .' + rowClass);
    $.each(cells, function(i, cell) {
      $(cell).val($(self).val());
    });

    $('.log-estimate-1').text(totalColumnValue('log-1')).change();
    $('.log-actual-1').text($('.log-estimate-1').text()).change();

    totalLogWorksCol();
    setRemainTime(rowClass);

    setRowColor(rowClass);
  }

  assigneeEventListener = function() {
    var filterRow = function(v) {return v.indexOf('row-') == 0}
    var rowClass = this.className.split(' ').filter(filterRow)[0];

    setRowColor(rowClass);
  }

  remainingEventListener = function() {
    var filterRow = function(v) {return v.indexOf('row-') == 0}
    var rowClass = this.className.split(' ').filter(filterRow)[0];
    var cells = $('.' + rowClass);

    setRowColor(rowClass);
  }

  setColorToday();
  $('.log').change(logWorkEventListener);

  $('.log-1').change(estimateEventListener);

  $('.assignee').change(assigneeEventListener);

  $('.remaining').change(remainingEventListener);

  $('.log-actual-1').change(function() {
    setActual(1);
  });
});

