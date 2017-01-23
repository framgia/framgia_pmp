$(document).on('page:change', function(){
  $('#setting_project a[data-toggle=tab]').on('shown.bs.tab', function(e){
    $('#add_member').height($('#add_member').parent().height());
  });

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
      $(this).data('ui-autocomplete')._renderItem = function(div, item){
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
    disableUsersInProject();

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
      if ($(this).hasClass('disabled') === false){
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
      }
      for (var i in member_to_add){
        users.push(member_to_add[i].user_name);
      }
      $('#add_member_project').val(users.join(','));
    });
    $('#add_member_project').data('members', member_to_add);
  });
}

function disableUsersInProject(){
  var users_in_project = [];
  $('#list_member_project tbody tr').each(function(){
    users_in_project.push($(this).find('td.member_name').data('user-id'));
  });
  for (var i in users_in_project){
    if (users_in_project[i]){
      var $input_checkbox = $('p.ui-menu-item').find('input[value='+users_in_project[i]+']');
      $input_checkbox.prop('checked', true);
      $input_checkbox.prop('disabled', true);
      $input_checkbox.closest('p').addClass('disabled');
    }
  }
}

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
        $('#add_member').height($('#add_member').parent().height());
        $('#add_member_project').data('members', []);
        $('#notify-message').text(I18n.t('projects.saved')).css('color', 'green');
      },
      error: function(data){
        $('#notify-message').text(I18n.t('projects.failed')).css('color', 'red');
      }
    });
  }
});

$(document).on('click', '.ui-menu-item', function(e){
  $('.ui-autocomplete').css('display', 'block');
});
