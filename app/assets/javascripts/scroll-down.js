window.scrollInfinite = {
  initialize: function() {
    _this = this;
    this.$container = $('#products-list');
    this.spinner = $($('#spinner-template').html());
    this.page = 2;
    this.onScroll();
    this.elementsSize = 0;
    this.isBottomOfPage = false;
    this.scrollAjaxStarted = false;
    this.initialized = true;
  },
  
  initialized: false,
  
  active: true,
  
  onScroll: function() {
    var _this = this;
    $(window).scroll(function() {
      if ( ($(window).scrollTop() >= ( ($(document).height() - $(window).height()) - 300 ) && !_this.isBottomOfPage && !_this.scrollAjaxStarted && _this.active)) {
        _this.scrollAjaxStarted = true;
        if(window.router.products)
          window.router.products.fetchNext();
        if(window.router.collections)
          window.router.collections.fetchNext();
        if(window.router.artists)
          window.router.artists.fetchNext();
        if(window.router.hallists)
          window.router.hallists.fetchNext();
      }
    });
  },
  
  bottomOfPage: function() {
    this.isBottomOfPage = true
  },
  
  ajaxComplete: function() {
    this.scrollAjaxStarted = false;
  }
}