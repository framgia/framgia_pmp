$(document).on('page:change', function(){
  $('#setting_project a:first').tab('show');

  setAutocompleteReturnItem();

  $('div[role=status]').css('display', 'none');
  $('#add_member_project').data('members', []);

  setValueInputForMembers();

  $('#add_member_project').on('input', function() {
    if(!$('#add_member_project').val()){
      $('#add_member_project').data('members', []);
    }
  });

  $('#add_member_project').bind('railsAutocomplete.select', function(event, data){
    event.preventDefault();
    var users = [];
    var members = $('#add_member_project').data('members');
    for (var i in members){
      users.push(members[i].user_name);
    }
    $('#add_member_project').val(users.join(','));
  });

  $('#add_member_project').click(function(){
    $('#notify-message').text('');
  });
});

$(document).mousedown(function(e) {
  if (e.target.id == 'delete_member' || $('#list_member_project').find(e.target).length == 0){
    var role = $('input#role_member[type=radio]:checked').next('span').html();
    $('input#role_member').closest('td').html(role);
  }

  if ($('.ui-autocomplete').find(e.target).length == 0){
    $('.ui-autocomplete').css('display', 'none');
  }
  else{
    $('.ui-autocomplete').css('display', 'block');
  }
});

function setAutocompleteReturnItem(){
  $('#add_member_project').autocomplete({
    create: function() {
      $(this).data('ui-autocomplete')._renderItem = function (div, item) {
        return $('<p></p>')
          .append('<input type="checkbox" value="'+item.id+'" id="add_new_member"> '+
            '<span>'+item.value+'</span>')
          .appendTo(div);
      };
    }
  });
}

function setValueInputForMembers(){
  $('#add_member_project').on('autocompleteopen', function(){
    $('.ui-autocomplete').width($('#add_member_project').width());
    $('div[role=status]').css('display', 'none');
    var member_to_add = $('#add_member_project').data('members');
    for (var i in member_to_add){
      $('p.ui-menu-item').find('input[value='+member_to_add[i].user_id+']').prop('checked', true);
    }

    $('p.ui-menu-item').click(function(e){
      var users = [];
      var $input = $(this).find('input');
      var user_id = $input.val();
      var user_name = $(this).find('span').html();
      var member = {user_id: user_id, user_name: user_name};
      var member_index = member_to_add.map(function(e) {return e.user_id;}).indexOf(user_id);
      if (e.target.id == 'add_new_member'){
        if ($input.is(':checked')){
          member_to_add.push(member);
        }
        else{
          if (member_index >= 0)
            member_to_add.splice(member_index, 1);
        }
      }
      else{
        if ($input.is(':checked')){
          $input.prop('checked', false);
          if (member_index >= 0)
            member_to_add.splice(member_index, 1);
        }
        else{
          $input.prop('checked', true);
          member_to_add.push(member);
        }
      }
      for (var i in member_to_add){
        users.push(member_to_add[i].user_name);
      }
      $('#add_member_project').val(users.join(','));
    });
    $('#add_member_project').data('members', member_to_add);
  });
}

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
  var role = $(this).find('input[type=radio]:checked').val();
  var users = $('#add_member_project').data('members');
  if (users.length == 0 && $('#add_member_project').val()){
    user_name = $('#add_member_project').val();
    users = [{user_name: user_name}];
  }
  if (users.length > 0){
    $.ajax({
      url: url,
      type: 'post',
      dataType: 'json',
      data: {
        role: role,
        users: users,
      },
      success: function(data){
        $('.ui-autocomplete').css('display', 'none');
        $('#list_member_project table tbody').append(data.content);
        $('#add_member_project').val('');
        var users = $('#add_member_project').data('members', []);
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

$(document).on('click', '.ui-menu-item', function(e){
  $('.ui-autocomplete').css('display', 'block');
});
