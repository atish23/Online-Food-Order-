# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(window).load ->
	$('.cart-item .fa').click (e) ->
		e.preventDefault()
		$this = $(this).closest('a')
		url = $this.data('targeturl')
		id = url.substring(url.lastIndexOf('/') + 1);
		$.ajax url: url, type: 'delete', success: (data) ->
			$('.cart-count').html(data+" Items")
			$('#list_'+id).slideUp();