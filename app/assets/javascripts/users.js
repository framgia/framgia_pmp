$(document).on("page:change", function() {
  jQuery(function() {
    $("#users").dataTable({
      sPaginationType: "full_numbers",
      bJQueryUI: true,
      bProcessing: true,
      bServerSide: true,
      aLengthMenu: [
        [5, 10, 20, 50, 100, -1],
        [5, 10, 20, 50, 100, "All"]
      ],
      "pageLength": 5,
      sAjaxSource: $("#users").data("source")
    });
  });
});
