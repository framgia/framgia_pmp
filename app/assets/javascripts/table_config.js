var items = ['.fixedTable-body', '.fixedTable-sidebar', 'div.pbody'];
const CELL_HEIGHT = 22, DELTA_WHEEL = 17, WHEEL_DELTA_TIME = 500, ADJUST_TIMES_WHEEL = 3;
const SCROLL_SPEED = CELL_HEIGHT * 2 / DELTA_WHEEL, SCROLL_SPEEDX = 40;
var lastScrollingTime = Date.now();
var lastWheelTime = Date.now();
var maxScrollTop = 0;
var wdY, wdX, posY, posX;
var tracked_delta;
var tracked_time_wheel;
var scb, tblBody, tblSidebar;

$(document).on("ready turbolinks:load", function(){
  load_tables();
  setNameCellWidth();
});

$.fn.hasHorizontalScrollBar = function(fixedWidth) {
  if (this.get(0) !== undefined) {
    return this[0].scrollWidth > fixedWidth;
  }
  return false;
};

$.fn.hasVerticalScrollBar = function(fixedHeight) {
  if (this.get(0) !== undefined) {
    return this[0].scrollHeight > fixedHeight;
  }
  return false;
};

$(window).on('resize', function(){
  load_tables();
  setNameCellWidth();
});

function setTableMaxHeight(tblElement) {
  var windowHeight = $(window).height();
  var topHeight = $('#top-menu').outerHeight();
  var headerHeight = $('#header').outerHeight();
  var titleHeight = $('h3.title').outerHeight();
  var pTitle = $('p.title-assignees-history');
  var pTitleHeight = 0;
  if (pTitle.length != 0 ) pTitleHeight = $('p.title-assignees-history').outerHeight() + 8;
  var headerTableHeight = $('.fixedTitle').outerHeight();
  var projectHeaderHeight = $('.pheader').outerHeight();
  var fixedBottomHeight = $('#fixed-bottom-body').outerHeight();
  var numberRecordHeight = $('#number-records').outerHeight();
  var fixedTableBody = $('.fixedTable-body');
  var fixedHeader = $('[class="fixedTable-header"]');

  if (fixedHeader.length == 0) {fixedHeader = $('.pheader');}
  if (fixedTableBody.length == 0) {fixedTableBody = $('.pbody');}

  var _scrollbar = $('.scrollbar');
  var _scrollbarH = $('.scrollbarH');
  var height = windowHeight - topHeight - headerHeight - titleHeight - headerTableHeight - projectHeaderHeight - numberRecordHeight - fixedBottomHeight - pTitleHeight - 55;

  if (fixedHeader.hasHorizontalScrollBar(fixedHeader.width()) && $('#salaries').length == 0) {
    _scrollbarH.css('max-width', fixedHeader.width());
    _scrollbarH.show();
  } else {
    _scrollbarH.hide();
    height += $('#salaries').length == 0 ? 15 : _scrollbarH.outerHeight();
  }

  if (fixedTableBody.hasVerticalScrollBar(height)) {
    var tableBodyMaxHeight = parseInt(fixedTableBody.css('max-height'), 10);
    _scrollbar.css({'max-height': tableBodyMaxHeight});
    _scrollbar.children().css('height', $('#list-records').height());
    _scrollbar.show();
  } else {
    _scrollbar.hide();
  }

  if (fixedTableBody.length == 0) {
    var realWidth = $('#projects .trow.header').outerWidth() + 15 ;
    $('.scrollbarH div').width(realWidth);
  }

  if (height > 200) {
    tblElement.css({'max-height': height});
  }
}

function load_tables(){
  tblBody = $('.fixedTable-body').first();
  scb = $('.scrollbar'), tblSidebar = $('.fixedTable-sidebar');

  $.each(items, function(_, element){
    if ($(element).length > 0) {
      setTableMaxHeight($(element));
    }
  });

  resetScrollConfig();
}

function setNameCellWidth() {
  var cellWidth = 0;
  var totalWidth = 0;
  var windowWidth = $(window).outerWidth();

  $('.trow:first div.tcell').not('[class*=name]').each(function(){
    totalWidth += $(this).outerWidth();
  });

  cellWidth = windowWidth - totalWidth - 24;

  if (cellWidth <= 158) {
    cellWidth = 158;
  }
}

function resetScrollConfig(){
  isScrolling = false;
  tracked_delta = 0;
  tracked_time_wheel = 0;
  wdY = 0, wdX = 0, posY = 0, posX = 0;
  maxScrollTop = tblBody.prop('scrollHeight') - tblBody.prop('clientHeight');
}

$(document).click(function(e){
  var divFilters = $('div.filters');
  if(divFilters.is(':visible')  && !isDatepicker($(e.target)) &&
    $(e.target).parents('div.filters').length === 0 && !$(e.target).hasClass('fa') &&
    e.target.className.indexOf('filters') === -1) {
    divFilters.hide();
  }
});

$(document).ready(function() {
  var _table = $('.table');
  var fixedTableBody = $('.fixedTable-body');
  var realWidth;

  if (fixedTableBody.length == 0) {
    fixedTableBody = $('.pbody');
    realWidth = $('.trow.header').outerWidth() + 25 ;
  } else {
    realWidth = $('.fixedTable-body > .tbody').width() - 2;
  }

  _table.append('<div class="scrollbar"></div><div class="bg_right"></div>');
  if ($('#salaries').length == 0) {
    _table.append('<div class="scrollbarH"></div>');
  }
  var _scrollbar = $('.scrollbar');
  var _scrollbarH = $('.scrollbarH');

  var tableBodyMaxHeight = parseInt(fixedTableBody.css('max-height'), 10);
  _scrollbar.css({'max-height': tableBodyMaxHeight-3});
  _scrollbarH.css('max-width', fixedTableBody.width());

  var realHeight = $('#list-records').height();
  $('.scrollbar').append('<div style="height:'+realHeight+'px; width: 1px;"></div>');
  $('.scrollbarH').append('<div style="width:'+realWidth+'px; height: 1px;"></div>');

  load_tables();
  setNameCellWidth();
  // detect browser
  navigator.sayswho= (function(){
    var N= navigator.appName, ua= navigator.userAgent, tem;
    var M= ua.match(/(opera|chrome|safari|firefox|msie)\/?\s*(\.?\d+(\.\d+)*)/i);
    if(M && (tem= ua.match(/version\/([\.\d]+)/i))!= null) M[2]= tem[1];
    M= M? [M[1], M[2]]: [N, navigator.appVersion,'-?'];
    return M;
  })();
  var is_sa_ie = (navigator.sayswho[0].toLowerCase().indexOf('safari') > -1) ||
    (navigator.sayswho[0].toLowerCase().indexOf('netscape') > -1);

  if (is_sa_ie) {
    $(items.toString()).on('mousewheel', function () {
      event.preventDefault();
      var deltaY;
      var deltaX;

      if (event.wheelDeltaY != undefined) {
        deltaY = -event.wheelDeltaY/120;
        deltaX = -event.wheelDeltaX/120;
      } else {
        deltaY = -event.wheelDelta/120;
        deltaX = 0;
      }

      deltaY = deltaY || 0 ;
      deltaX = deltaX || 0 ;

      adjust_wheel(deltaX, deltaY);
    });
  } else if ('onwheel' in document.createElement('div')) {
    $(items.toString()).on('wheel', function (event) {
      event.preventDefault();
      var deltaY = (event.originalEvent.deltaY/3) || 0 ;
      var deltaX = (event.originalEvent.deltaX/3) || 0 ;

      adjust_wheel(deltaX, deltaY);
    });
  }

  _scrollbar.scroll(function() {
    $('.filters').hide();
    posY = scb.scrollTop();
    syncScrollTable(posY);
  });

  _scrollbarH.scroll(function() {
    var left = $(this).scrollLeft();
    $('.fixedTable-body').scrollLeft(left);
    $('.fixedTable-header').scrollLeft(left);

    $('#projects .pheader').scrollLeft(left);
    $('#projects .pbody').scrollLeft(left);
    $('.filters').hide();
  });

  function adjust_wheel(deltaX, deltaY){
    var adjust_wheel = DELTA_WHEEL;
    tracked_time_wheel += Date.now() - lastWheelTime ;
    if (tracked_time_wheel < WHEEL_DELTA_TIME ) {
      var adjust_times = ADJUST_TIMES_WHEEL;
      adjust_wheel *= adjust_times;
    }else {
      tracked_time_wheel = 0;
    }

    var directionY =  deltaY > 0 ? 1 : deltaY < 0 ? -1 : 0 ;
    wdY += directionY*adjust_wheel;

    wdX += deltaX;
    updateScrollBars();
    syncScroll(posY);
  }

  function updateScrollBars() {
    var absWDY = Math.abs(wdY);
    var absWDX = Math.abs(wdX);
    var directionY =  wdY * absWDY > 0 ? 1 : wdY * absWDY < 0 ? -1 : 0 ;
    var directionX =  wdX * absWDX > 0 ? 1 : wdX * absWDX < 0 ? -1 : 0 ;

    var number_of_row = Math.floor(absWDY * SCROLL_SPEED / CELL_HEIGHT);
    if (absWDY > absWDX) {
      wdY = directionY * number_of_row * CELL_HEIGHT;
      wdX = 0;
    } else if (absWDX > absWDY) {
      wdX = directionX * SCROLL_SPEEDX;
      wdY = 0;
    } else {
      wdY = directionX * number_of_row * CELL_HEIGHT;
      wdX = 0;
    }

    var cspX = _scrollbarH.scrollLeft();
    posY += wdY;
    posY = posY < 0 ? 0 : posY;
    posY = posY < maxScrollTop ? posY : maxScrollTop;
    posX = cspX + wdX;

    _scrollbarH.scrollLeft(posX);

    wdX = 0;
    wdY = 0;
  }

  function syncScroll(pos) {
    lastScrollingTime = Date.now();
    tblBody.scrollTop(pos);
    tblSidebar.scrollTop(pos);
    scb.scrollTop(pos);
  }

  function syncScrollTable(pos) {
    lastScrollingTime = Date.now();
    tblBody.scrollTop(pos);
    tblSidebar.scrollTop(pos);
  }
});
