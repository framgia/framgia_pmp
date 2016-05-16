$(document).on("page:change", function() {
  var sprint_id = $("#spint_id").data("sprint");
  var link = "/api/sprints/" + sprint_id
  cfg = {
    sheet: "111",
    parent: "gridbox",
    dhx_rel_path: link
  }
  /*! INITIALIZATION */
  var dhx_sh;
  function onload_func() {
    window.setTimeout(function() {
      dhx_sh = new window.dhtmlxSpreadSheet({
        load: window.cfg.load || window.cfg["dhx_rel_path"],
        save: window.cfg.save || window.cfg["dhx_rel_path"],
        parent: window.cfg.parent || null,
        icons_path: "/assets/dhtmlx/imgs/icons/",
        image_path: "/assets/dhtmlx/imgs/",
        skin: window.cfg.skin || 'dhx_skyblue',
        autowidth: true,
        autoheight: true,
        math: true
      });
      dhx_sh.load(window.cfg.sheet||"1", window.cfg.key||null);
    }, 1);
  }
  onload_func();
});
