// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// for zebra striping tables. 
// from http://blog.internautdesign.com/2007/11/30/zebra-striping-with-prototype

Event.observe( window, 'DOMContentLoaded', function() {

  $$('.zebra').each( function(e) {
    Selector.findChildElements(e, ['tr','li']).each( function(e, idx) {
      e.addClassName( idx % 2 == 1 ? 'odd' : 'even');
    });    
  });

});