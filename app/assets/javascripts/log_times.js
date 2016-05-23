$(document).on("ready", function(){
  $("#lost_hour_form").submit(function(e) {

      $("#lost_hour_table input").each(function(index, obj){
          if($(obj).val() == "") {
              $(obj).attr("name", "");
          }
      });

      $.ajax({
             type: "POST",
             url: $("#lost_hour_form").attr("action"),
             data: $("#lost_hour_form").serialize(),
             success: function(data){}
           });
      e.preventDefault();
  });
});
