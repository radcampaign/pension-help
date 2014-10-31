// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require prototype
//= require prototype_ujs
//= require effects
//= require dragdrop
//= require controls
//= require jquery
//= require jquery_ujs
//= require tinymce
//= require tinymce-jquery
//= require maskedinput
//= require admin_save_reminder
//= require print
//= require_tree .

jQuery.noConflict();

jQuery(function() {

  jQuery.fn.increaseFontsize = function(size, speed, easing, callback) {
    return this.animate({
      fontSize: size
    }, speed, easing, callback);
  };

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
