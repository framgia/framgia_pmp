$(document).on('page:change', function (){
  getData();

  $('#user-reset').click(function(){
    $('input:checkbox[class=user-select]').each(function() {
      $(this).prop('checked', false);
    });
    getData();
  });

  $('.user-select').click(function() {
    getData();
  });

  $('.chart-type > input:radio').click(function() {
    getData();
  });

  $('#create-work-performance').click(function(){
    submitWorkPerformanceInput();
  });
});

function submitWorkPerformanceInput(){
  var project = $('#create-work-performance').data('project');
  var sprint = $('#create-work-performance').data('sprint');
  $.ajax({
    url: '/projects/'+project+'/sprints/'+sprint+'/work_performances/new',
    type: 'GET',
    data: {},
    dataType: 'json',
    success: function(result){
      $('#dialog h3').html("<i class='glyphicon glyphicon-pencil'></i> Input Work Performance Data");
      $('.modal-body').html(result.wpd_content);
      checkWorkPerformances();
      $('#work_performance_master_sprint_id').on('change', function(){
        checkWorkPerformances();
      });
      $('#work_performance_activity_id').on('change', function(){
        checkWorkPerformances();
      });
    }
  });
}

function checkWorkPerformances(){
  var master_sprint_id = $('#work_performance_master_sprint_id').val();
  var activity_id = $('#work_performance_activity_id').val();
  var sprint_id = $('#work_performances__sprint_id').val();
  $.ajax({
    url: '/ajax/check_work_performances',
    type: 'POST',
    data: {
      master_sprint_id: master_sprint_id,
      activity_id: activity_id,
      sprint_id: sprint_id
    },
    dataType: 'json',
    success: function(result){
      if (result.check == 0){
        createWPD(result);
      }
      else{
        updateWPD(result);
      }
    }
  });
}

function createWPD(result){
  $('form#form-input-wpd').submit(function(e){
    e.preventDefault();
    var url = $(this).attr('action');
    var data = $(this).serializeArray();
    console.log(data);
    $.ajax({
      url: url,
      type: 'POST',
      data: data,
      dataType: 'json',
      success: function(result){
        $('#dialog').modal('toggle');
        getData();
      }
    });
  });
}

function updateWPD(result){
  for (var i in result.wpds){
    var id = result.wpds[i].item_performance_id;
    $('#wpd-input-'+id).find('input#work_performances__performance_value').val(result.wpds[i].performance_value);
    $('#wpd-input-'+id).append('<input value="'+result.wpds[i].id+'" type="hidden" name="work_performances[][id]" id="work_performances_id"></input>');
  }
  $('form#form-input-wpd').submit(function(e){
    e.preventDefault();
    var url = $(this).attr('action');
    var data = $(this).serializeArray();
    console.log(data);
    $.ajax({
      url: url,
      type: 'PATCH',
      data: data,
      dataType: 'json',
      success: function(result){
        $('#dialog').modal('toggle');
        getData();
      }
    });
  });
}

function getData(){
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
        chart_type: chart_type
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
