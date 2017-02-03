$(document).on('page:change', function (){
  getData();

  setWorkPerformanceHeight();

  $(window).resize(function() {
    setWorkPerformanceHeight();
  });

  $('#user-reset').click(function(){
    $('input:checkbox[class=user-select]').each(function() {
      $(this).prop('checked', false);
    });
    getData();
  });

  $('#view-all,.chart-type > input:radio').click(function() {
    getData();
  });

  $('#compare-wpd').click(function() {
    getData('compare');
  });

  $('#wpd-dialog').on('shown.bs.modal', function(){
    submitWorkPerformanceInput();
  });

  $('td.date-of-project').on('change', function(){
    $('a#save-sprint').click(function(){
      updateSelectMasterSprintOnForm();
    });
  });
});

function submitWorkPerformanceInput(){
  getActivitiesOfUser();
  $('#work_performance_user_id').on('change', function(){
    getActivitiesOfUser();
  });
  $('#work_performance_master_sprint_id,#work_performance_task_id,#work_performance_phase_id')
    .on('change', function(){
    checkWorkPerformances();
  });

  $('form#form-input-wpd').submit(function(e){
    e.preventDefault();
    var url = $(this).attr('action');
    var data = $(this).serializeArray();
    $.ajax({
      url: url,
      type: 'POST',
      data: data,
      dataType: 'json',
      success: function(result){
        $('#wpd-dialog').modal('hide');
        updateWPDtable(result);
        getData();
      }
    });
  });
}

function setWorkPerformanceHeight(){
  $('.work_performances').outerHeight($(window).height() -
    $('header').outerHeight() - $('#category-tab').outerHeight() - 30);
}

function updateWPDtable(result){
  var current_phase_id = $('#phase').val();
  var wpd = result.wpd;
  if (wpd[0].phase_id == current_phase_id){
    for (var i in wpd){
      var task_id = wpd[i].task_id;
      var day_id = wpd[i].master_sprint_id;
      if ($('.task-'+task_id+'-wpd-'+wpd[i].id).length >0){
        $('.task-'+task_id+'-wpd-'+wpd[i].id).html(wpd[i].performance_value);
      }
      else{
        $('.wpd-master-sprint-'+day_id+'.task-id-'+task_id).append('<p class="task-'
          +task_id+'-wpd-'+wpd[i].id+'">'+wpd[i].performance_value+'</p>');
      }
    }
    $('.total_performance .total-wpd-in-day-'+wpd[0].master_sprint_id).html(result.total_wpd);
  }
}

function getActivitiesOfUser(){
  var user_id = $('#work_performance_user_id').val();
  var sprint_id = $('#work_performance_sprint_id').val();
  var project_id = $('form#form-input-wpd').data('project');
  if (sprint_id && project_id){
    $.ajax({
      url: '/api/projects/'+project_id+'/sprints/'+sprint_id+'/tasks',
      dataType: 'json',
      data: {
        user_id: user_id
      },
      success: function(result){
        fill_up_task_select(result.tasks);
      }
    });
  }
}

function checkWorkPerformances(){
  var master_sprint_id = $('#work_performance_master_sprint_id').val();
  var task_id = $('#work_performance_task_id').val();
  var sprint_id = $('#work_performance_sprint_id').val();
  var phase_id = $('#work_performance_phase_id').val();
  if (sprint_id){
    $.ajax({
      url: '/ajax/work_performances',
      type: 'GET',
      data: {
        master_sprint_id: master_sprint_id,
        task_id: task_id,
        sprint_id: sprint_id,
        phase_id: phase_id
      },
      dataType: 'json',
      success: function(result){
        if (result.existed == 'false'){
          $('#work_performance_performance_value').val('');
        }
        else{
          $('#work_performance_performance_value').val('');
          $('#work_performance_performance_value').val(result.wpds[0].performance_value);
        }
      }
    });
  }
}

function fill_up_task_select(tasks){
  $('select#work_performance_task_id').empty();
  if (tasks.length > 0){
    for (var i in tasks){
      $('#work_performance_task_id').append('<option value="'+tasks[i].id
        +'">'+tasks[i].subject+'</option>');
    }
  }
  checkWorkPerformances();
}

function updateSelectMasterSprintOnForm(){
  var $dates = $('td.date-of-project');
  var number_cols = $dates.length;
  var $form_select_day = $('form#form-input-wpd select#work_performance_master_sprint_id');
  $form_select_day.find('option[selected=selected]').removeAttr('selected');
  for (var i=0; i< number_cols; i++){
    var date = new Date($dates.eq(i).find('input.master-sprint-date').val()).toDateString().substring(4);
    var day = parseInt($('th.master-sprint-day-header').eq(i).text());
    var master_sprint_id = $('th.master-sprint-day-header').eq(i).data('master-sprint');
    $form_select_day.find('option[value='+master_sprint_id+']').text('Day '+day+' - '+date);
    if (date == new Date().toDateString().substring(4)){
      $form_select_day.find('option[value='+master_sprint_id+']').attr('selected', 'selected');
    }
  }
}

function getData(view_type = "view_all"){
  var performance_chart = $('#performance_chart');

  var users = [];
  var chart_type = $('.chart-type > input:radio:checked').val();
  $('input:checkbox[class=user-select]:checked').each(function() {
    users.push($(this).val());
  });

  var project = $('#performance_chart').data('project');
  var sprint = $('#performance_chart').data('sprint');

  if(project && sprint){
    $.ajax({
      url: '/api/projects/'+project+'/sprints/'+sprint+'/work_performances',
      data: {
        users: users,
        chart_type: chart_type,
        view_type: view_type
      },
      dataType: 'json',
      success: function(data) {
        if (performance_chart.length > 0){
          initPerformanceChart(data);
        }
      }
    });
  }
}

function initPerformanceChart(data){
  var options = {
    chart: {
      renderTo: 'performance_chart',
      height: 350,
      width: 600,
      borderWidth: 1
    },
    title: {
      text: 'Work Performance Chart',
      x: -20
    },
    xAxis: {
      tickInterval: 1,
      min: 0,
      title: {text: 'Working days (day)'},
      gridLineWidth: 1
    },
    yAxis: {
      title: {text: 'Value'},
      lineWidth: 1,
      gridLineWidth: 1
    },
    credits: {
      enabled: false
    },
    tooltip: {
      shared: true,
      useHTML: true,
      hideDelay: 10,
      borderColor: '#7cb5ec',
      headerFormat: '<div style="text-align: center">Day' + ': <b>{point.key}</b></div>'
    },
    legend: {
      align: 'right',
      layout: 'vertical'
    },
    series: []
  };

    for (var i in data){
      options.series.push(data[i])
    }
    var chart = new Highcharts.Chart(options);
}
