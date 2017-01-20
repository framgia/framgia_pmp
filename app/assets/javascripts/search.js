$(document).on('turbolinks:load', function(){
  $('input').keydown(function(){
    $('input').css('background-color', 'red');
    var q = $('#q').val();
    $.ajax({
      url: 'searches',
      type: 'get',
      data: {q: q},
      dataType: 'json',
      success: function(data){
        $('table#tbl-list-project tbody').empty();
        $('table#tbl-list-project tbody').append(data.content);
      }
    });
  });
  $('input').keyup(function(){
    $('input').css('background-color', 'pink');
    var q = $('#q').val();
    $.ajax({
      url: 'searches',
      type: 'get',
      data: {q: q},
      dataType: 'json',
      success: function(data){
        $('table#tbl-list-project tbody').empty();
        $('table#tbl-list-project tbody').append(data.content);
      }
    });
  });
});
