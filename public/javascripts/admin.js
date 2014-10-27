jQuery(document).ready(function(){
	jQuery(".admin_form fieldset legend").click(function() {
		jQuery(this).siblings().not("script").toggle(500);
	});
});