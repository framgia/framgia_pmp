$(document).ready(function() {
  cfg = {
    sheet: '111',
    parent: 'gridbox',
    dhx_rel_path: '/api/sprints'
  }

  /*! INITIALIZATION */
  var dhx_sh;
  function onload_func() {
    window.setTimeout(function() {
      dhx_sh = new window.dhtmlxSpreadSheet({
        load: window.cfg.load || window.cfg['dhx_rel_path'],
        save: window.cfg.save || window.cfg['dhx_rel_path'],
        parent: window.cfg.parent || null,
        icons_path: "/assets/imgs/icons/",
        image_path: "/assets/imgs/",
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
