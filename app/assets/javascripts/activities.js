$(document).on('page:change', function(){
  $('[data-toggle="tooltip"]').tooltip();
  // total log_works
  function totalLogWorksCol() {
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

  function setActual(col) {
    var workHour = parseInt($("#work-hour-0" + " input").val());

    var cells = $('th[class*="log-actual"]');
    for(++col; col < cells.length; col++) {
      var lostHour = parseInt($("#lost-hour-" + col + " input").val());
      $(cells[col]).text(parseInt($(cells[col-1]).text()) + lostHour - workHour);
    }
  }

  function worked() {
    var estimated = parseInt($('.log-estimate-0').text());
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
    var estimateValue = $('.estimate.' + rowClass).val();

    var cells = $('.' + rowClass);

    // assignee is empty
    if(assigneeValue == '') {
      if(estimateValue != '0') {
        if(remainingValue != '0') {
          cells.addClass('estimated');
          cells.removeClass('assigned default processed');
        } else {
          cells.addClass('default');
          cells.removeClass('assigned estimated processed');
        }
      }
      else {
        cells.removeClass('estimated assigned processed');
        cells.addClass('default');
      }
    } else {
      if(estimateValue != '0') {
        if(remainingValue != '0') {
          cells.removeClass('assigned default estimated');
          cells.addClass('processed');
        } else {
          cells.removeClass('assigned processed estimated');
          cells.addClass('default');
        }
      }
      else {
        cells.removeClass('processed default estimated');
        cells.addClass('assigned');
      }
    }
  }

  $('.log').change(function() {
    var filterRow = function(v) {return v.indexOf('row-') == 0}
    var rowClass = this.className.split(' ').filter(filterRow)[0];

    var filterLog = function(v) {return v.indexOf('log-') == 0}
    var logClass = this.className.split(' ').filter(filterLog)[0];

    var cells = $('.panel-left .' + rowClass);
    var i = parseInt(logClass.split('-')[1]) + 1;
    for(++i; i < cells.length; i++) {
      $(cells[i]).val($(this).val());
    }

    totalLogWorksCol();
    setRemainTime(rowClass);
  });

  $('.estimate').change(function() {
    var self = this;
    var filterRow = function(v) {return v.indexOf('row-') == 0}
    var rowClass = this.className.split(' ').filter(filterRow)[0];
    var cells = $('.panel-left .' + rowClass);
    $.each(cells, function(i, cell) {
      $(cell).val($(self).val());
    });

    $('.log-estimate-0').text(totalColumnValue('estimate')).change();
    $('.log-actual-0').text($('.log-estimate-0').text()).change();

    totalLogWorksCol();
    setRemainTime(rowClass);

    setRowColor(rowClass);
  });

  $('.assignee').change(function() {
    var filterRow = function(v) {return v.indexOf('row-') == 0}
    var rowClass = this.className.split(' ').filter(filterRow)[0];

    setRowColor(rowClass);
  });

  $('.remaining').change(function() {
    var filterRow = function(v) {return v.indexOf('row-') == 0}
    var rowClass = this.className.split(' ').filter(filterRow)[0];
    var cells = $('.' + rowClass);

    setRowColor(rowClass);
  });

  $('.log-actual-0').change(function() {
    setActual(0);
  });
});
