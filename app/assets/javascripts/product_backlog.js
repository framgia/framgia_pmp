var tabName = "pb_tab_show";
function initGrid(){
  myGrid = new dhtmlXGridObject('product_backlog_input');
  myGrid.setImagePath("assets/imgs/");
  myGrid.setHeader("Priority, Estimate, Actual, Remaining, Project, Remove");
  myGrid.setInitWidths("70,70,70,100,200,70");
  myGrid.setColAlign("center,center,center,center,center,center");
  myGrid.setColTypes("ed,ed,ed,ed,ro,ro");
  myGrid.setColSorting("int,str,str");
  myGrid.setSkin("dhx_blue");
  myGrid.init();
  myGrid.enableResizing("false,false,false,false");

  myGrid.attachEvent("onRowCreated", function(id){
    myGrid.cells(id, 5).setValue("<button class='btn btn-xs btn-danger'>" +
      "<span class='glyphicon glyphicon-trash'></span></button");
   return true;
  });

  myGrid.attachEvent("onRowSelect", function(id, index){
   if (index == 5)
       myGrid.deleteSelectedRows();
   return true;
  });

  project_column = myGrid.getCombo(4);

  dp = new dataProcessor($("#product_backlog_input").data("updateApi"));
  dp.setTransactionMode("POST", false);
  dp.setUpdateMode("row");
  dp.init(myGrid);
  $.ajax({
   url: $("#product_backlog_input").data("loadApi"),
   async: true,
   dataType: 'json',
    success: function(data) {
      myGrid.parse(data, 'json');
      projects = data.projects;
      for (i in projects) {
        project_column.put(projects[i].id, projects[i].name);
      }
      isLoad = true;
    },
    error: function(msg) {
    }
  });
  isLoad = true;
}

$(document).on('click', '#pb_tab_show', function() {
  tabName = "pb_tab_show"
});

$(document).on("page:change", function(){
  if(tabName == "pb_tab_show"){
    initGrid();
    tabName = "";
  }
});

$(document).on('click', '#add_more_pb', function() {
  myGrid.addRow(myGrid.uid(),'')
});
