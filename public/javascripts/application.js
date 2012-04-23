// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// for zebra striping tables.
// from http://blog.internautdesign.com/2007/11/30/zebra-striping-with-prototype
Event.observe(window, 'DOMContentLoaded', function() {

  $$('.zebra').each(function(e) {
    Selector.findChildElements(e, ['tr', 'li']).each(function(e, idx) {
      e.addClassName(idx % 2 == 1 ? 'odd' : 'even');
    });
  });

  (function($) {
    $.fn.increaseFontsize = function(size, speed, easing, callback) {
      return this.animate({
        fontSize: size
      }, speed, easing, callback);
    };
  })(jQuery);

  alert("aaaa")

  jQuery(function() {
    jQuery('.font').click(function() {
      if (jQuery(this).attr('class') == "small font") {
        jQuery('body, p, div, td, tr,label').increaseFontsize(10, 'fast');
      }
      if (jQuery(this).attr('class') == "medium font") {
        jQuery('body, p, div, td, tr,label').increaseFontsize(13, 'fast');
      }
      if (jQuery(this).attr('class') == "big font") {
        jQuery('body, p, div, td, tr,label').increaseFontsize(17, 'fast');
      }
    });
  });

});
