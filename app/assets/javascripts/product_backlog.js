$(document).on("click", ".delete-product-backlog", function(e){
  var product_backlog_id = $(this).data("product-backlog-id");
  var project_id = $(this).data("project-id");
  $.ajax({
      type: "DELETE",
      url:  "/projects/" + project_id + "/product_backlogs/" + product_backlog_id,
      dataType: "json",
      success: function() {
        $("#backlog-row-"+ product_backlog_id).remove();
        $("#notify-message").text(I18n.t("product_backlogs.delete.success")).css("color", "green");
        change_style_table();
      },
      error: function(){
        $("#notify-message").text(I18n.t("product_backlogs.delete.failed")).css("color", "red");
      }
    });
});

$(document).ready(function(){
  $(".product-backlog-story").tooltip();
  $(".product-backlog-category").tooltip();
  change_style_table();
  $('.tbl1-product-backlog').width('96.3%');
});

function change_style_table(){
  if($('#tbl-product-backlog_body').height()<335){
    $('.tbl2-product-backlog').width('96.27%');
  }else{
    $('.tbl2-product-backlog').width('97.7%');
  }
}

$(document).on("page:change", function() {
  change_style_table();
  $("#product_backlogs").on("click", "#add-more-row", function(e){
    var project_id = $(this).find("span").attr("project_id");
    var url = $(this).attr("href");
    $.ajax({
      type: "POST",
      url:  url,
      dataType: "json",
      data: {id: project_id},
      success: function(result) {
        var row_number = result.row_number;
        $("table#product_backlogs tbody").append(result.content);
        $(".product-backlog-category-" + row_number).focus();
        change_style_table();
      },
      error: function(){
        $("#notify-message").text(I18n.t("product_backlogs.delete.failed")).css("color", "red");
      }
    });
    return false;
  });

  $("#save-product-backlog").on("click", function(){
    $("#notify-message").text(I18n.t("product_backlogs.saving"));
    $.ajax({
      type: "PATCH",
      url: "/update_product_backlogs",
      data: $("#product_backlog_form").serialize(),
      dataType: "json",
      success: function(data) {
        $('#save-product-backlog').addClass("disabled");
        $("#notify-message").text(I18n.t("product_backlogs.saved")).css("color", "green");
      },
      error: function(data) {
        $("#notify-message").text(I18n.t("product_backlogs.failed")).css("color", "red");
      }
    });
  });

  $("#product_backlog_form").on("change", "input, select", function(){
    $('#save-product-backlog').removeClass("disabled");
  });
});

$(document).on("keyup", ".story", function(event) {
  if(event.which == 13) {
    $("#add-more-row").click();
  }
});
