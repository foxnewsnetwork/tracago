$(document).ready ->
  $($('[data-hover-hide]').attr 'data-hover-hide').hide()
  $('[data-hover-show][data-hover-hide]').mouseenter ->
    $($(this).attr 'data-hover-hide').hide()
    $($(this).attr 'data-hover-show').show()

