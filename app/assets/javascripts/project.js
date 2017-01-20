$(document).on('page:change', function(){
  $('#setting_project a:first').tab('show');
  $('#add_member_project').on('autocompleteopen', function(){
    $('.ui-autocomplete').width($('#add_member_project').width());
    $('div[role=status]').css('display', 'none');
  });
  $('#add_member_project').bind('railsAutocomplete.select', function(event, data){
    $('#add_member_project').data('member_user_id', data.item.id);
  });
});

$(document).mousedown(function(e) {
  if (e.target.id == 'delete_member' || $('#list_member_project').find(e.target).length == 0){
    var role = $('input#role_member[type=radio]:checked').next('span').html();
    $('input#role_member').closest('td').html(role);
  }
});

$(document).on('click', '#edit_role_member', function(e){
  var project = $('#list_member_project').data('project');
  var member = parseInt($(this).closest('tr').attr('class').split('-').pop());
  var role = $('input#role_member[type=radio]:checked').next('span').html();
  $('#notify-message').text('');
  $('input#role_member').closest('td').html(role);
  $.ajax({
    url: '/projects/'+project+'/project_members/'+member,
    dataType: 'json',
    data: {id: member},
    success: function(data){
      var $role = $('tr.member-'+member+' td.member_role');
      var project_roles = data.project_roles;
      $role.empty();
      for (i in project_roles){
        $role.append('<input type="radio" name="role_member_'+member+
          '" id="role_member'+'" value="'+i+'"> '+'<span>'+project_roles[i]+'</span><br>');
      }
      $role.find('input[value='+data.current_role+']').prop('checked', true);
    }
  });
});

$(document).on('click', 'td.member_role input', function(){
  var project = $('#list_member_project').data('project');
  var member = parseInt($(this).closest('tr').attr('class').split('-').pop());
  var role = $('td.member_role input[type=radio]:checked').val();
  $.ajax({
    url: '/projects/'+project+'/project_members/'+member,
    type: 'patch',
    data: {
      id: member,
      role: role
    },
    dataType: 'json',
    success: function(data){
      $('tr.member-'+member+' td.member_role').html(data.new_role);
      $('#notify-message').text(I18n.t('projects.saved')).css('color', 'green');
    },
    error: function(data){
      $('#notify-message').text(I18n.t('projects.failed')).css('color', 'red');
    }
  });
});

$(document).on('click', '#delete_member', function(){
  var project = $('#list_member_project').data('project');
  var $tr = $(this).closest('tr');
  var member = parseInt($tr.attr('class').split('-').pop());
  var answer = confirm(I18n.t('delete.confirm'));
  if (answer){
    $.ajax({
      url: '/projects/'+project+'/project_members/'+member,
      type: 'delete',
      data: {id: member},
      dataType: 'json',
      success: function(data){
        $tr.remove();
        resetMemberIndex();
        $('#notify-message').text(I18n.t('projects.delete.success')).css('color', 'green');
      },
      error: function(){
        $('#notify-message').text(I18n.t('projects.delete.failed')).css('color', 'red');
      }
    });
  }
});

$(document).on('submit', 'form#form_add_member', function(e){
  e.preventDefault();
  var url = $(this).attr('action');
  var data = $(this).serializeArray();
  var user_id = $('#add_member_project').data('member_user_id');
  if (user_id){
    data.push({name: 'user_id', value: user_id});
  }
  if ($('#add_member_project').val()){
    $.ajax({
      url: url,
      type: 'post',
      dataType: 'json',
      data: data,
      success: function(data){
        $('#list_member_project table tbody').append(data.content);
        $('#add_member_project').val('');
        $('#notify-message').text(I18n.t('projects.saved')).css('color', 'green');
      },
      error: function(data){
        $('#notify-message').text(I18n.t('projects.failed')).css('color', 'red');
      }
    });
  }
});

function resetMemberIndex(){
  $('#list_member_project tbody tr').each(function(index){
    $(this).find('.index').html(index + 1);
  });
}

$(document).on('page:change', function(){
  $('#closed').click(function() {
    if ($('#closed').is(':checked')) {
      $(this).val("closed");
      var status = 2;
      $.ajax({
        url: 'api/projects',
        type: 'get',
        data: {status: status},
        dataType: 'json',
        success: function(data){
          $('table#tbl-list-project tbody').empty();
          $('table#tbl-list-project tbody').append(data.content);
        }
      });
    } else {
      $(this).val("not_closed");
      $.ajax({
        url: 'projects',
        type: 'get',
        data: {status: "projects_is_not_closed"},
        dataType: 'json',
        success: function(data){
          $('table#tbl-list-project tbody').empty();
          $('table#tbl-list-project tbody').append(data.content);
        }
      });
    }
  });
});

$(document).ready(function() {
  $('.submit_on_enter').keydown(function(event) {
    if (event.keyCode == 13) {
      window.location.href("<%= searches_path %>");
    }
  });
  $('.submit_on_enter').keyup(function(event) {
    if (event.keyCode == 13) {
      window.location.href("<%= searches_path %>");
    }
  });
});
