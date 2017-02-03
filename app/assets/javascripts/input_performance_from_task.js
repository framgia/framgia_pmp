$(document).on('page:change', function(){
  $('#activities tr td.index').hover(function(){
    var current_user = $(this).data('current-user');
    var task_user = parseInt($(this).closest('tr').find('.assignee-name select').val());
    var task_name = $(this).closest('tr').find('.task-name input').val();
    var dialog = $('#input_performance_dialog').length;
    if (task_name && current_user === task_user && dialog == 0){
      resetIndexColumTask();
      var index = $(this).find('.text-center').html();
      $(this).find('.text-center').html('<i class="fa fa-pencil-square-o"'+
        'aria-hidden="true"></i>');
      $(this).attr('id', 'input_wpd');
      $(this).attr('title', 'Input Performance');
    }
  });
});

$(document).on('change', '#work_performance_master_sprint_id, #work_performance_phase_id',
    function(){
  checkWorkPerformances();
});

$(document).mousedown(function(e) {
  if ($('#input_wpd').find(e.target).length == 0){
    if ($('#input_performance_dialog').length >0){
      $('#input_performance_dialog').remove();
      resetIndexColumTask();
    }
    else{
      resetIndexColumTask();
    }
  }
});

$(document).on('click', '#activities td#input_wpd', function(event){
  var task_id = $(this).data('task');
  if ($('#input_performance_dialog').length == 0){
    initInputPerformanceDialog(event, task_id);
    return false;
  }
});

$(document).on('click', 'form#form-input-wpd input[type=submit]', function(e){
  e.preventDefault();
  $('#notify-message').text(I18n.t('sprints.saving'));
  var url = $('form#form-input-wpd').attr('action');
  var data = $('form#form-input-wpd').serializeArray();
  $.ajax({
    url: url,
    type: 'POST',
    data: data,
    dataType: 'json',
    success: function(result){
      $('#input_performance_dialog').remove();
      resetIndexColumTask();
      $('#notify-message').text(I18n.t('sprints.success')).css('color', 'green');
    },
    error: function(data){
      $('#notify-message').text(I18n.t('sprints.failed')).css('color', 'red');
    }
  });
});

function resetIndexColumTask(){
  var $tr_prev = $('#activities td.index#input_wpd').closest('tr').prevAll('tr').first();
  var index = 1;
  if ($tr_prev.length > 0)
    index = (parseInt($tr_prev.find('td.index .text-center').html()) + 1);
  $('#activities tr td.index#input_wpd').find('.text-center').html(index);
  $('#activities tr td.index#input_wpd').removeAttr('id');
}

function initInputPerformanceDialog(event, task_id){
  if ($('#input_performance_dialog') !== null){
    $('#input_performance_dialog').remove();
  }
  $.ajax({
    url: '/rows/'+task_id,
    data: {id: task_id},
    success: function(data){
      $(event.target).after(data);
      $left = event.pageX + 'px';
      if (event.pageY + 430 > $(window).height())
        $top = $(window).height() - 440 + 'px'
      else
        $top = event.pageY + 'px';
      $('#input_performance_dialog').css({'left': $left, 'top': $top});
      $('#input_performance_dialog').removeClass('dialog-hidden');
      $('#input_performance_dialog').addClass('dialog-visible');
      $('#input_performance_dialog').find('input[type=submit]').css('background', '#3279b6');
      checkWorkPerformances();
    }
  });
}
