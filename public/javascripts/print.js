function addLoadEvent(func) {
  var oldonload = window.onload;
  if (typeof window.onload != 'function') {
    window.onload = func;
  } else {
    window.onload = function() {
      if (oldonload) {
        oldonload();
      }
      func();
    }
  }
}

addLoadEvent( function(){ add_print_link( 'nav' ) } );

function add_print_link( id ){
  if( !document.getElementById ||
      !document.getElementById( id ) ) return;

  // add extra functions to page tools list
  var print_page = document.getElementById( id );

  // create print link
  var print_function = document.createElement('p');
  print_function.className = 'print-link';
  print_function.onclick = function(){ print_preview(); return false; };
  print_function.appendChild( document.createTextNode( 'Print the Page' ) );

}

function print_preview() {
	// Switch the stylesheet
	setActiveStyleSheet('Print Preview');

	// Print the page
	window.print();
}

function cancel_print_preview() {
	// Destroy the preview message
	var print_preview = document.getElementById('preview-message');
	var main_body = print_preview.parentNode;
	main_body.removeChild(print_preview);

	// Switch back stylesheet
	setActiveStyleSheet('default');
}

function setActiveStyleSheet(title) {
   var i, a, main;
   for(i=0; (a = document.getElementsByTagName("link")[i]); i++) {
     if(a.getAttribute("rel").indexOf("style") != -1
        && a.getAttribute("title")) {
       a.disabled = true;
       if(a.getAttribute("title") == title) a.disabled = false;
     }
   }
}