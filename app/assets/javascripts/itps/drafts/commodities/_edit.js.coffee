# $('.item-form form').submit ->
#   values = $(this).serialize()
#   $.ajax
#     url: $(this).attr('action'),
#     data: values,
#     dataType: 'JSON',
#     type: $(this).attr('method')
#   .success (json) ->
#     console.log 'success'
#   .fail (json) ->
#     console.log json
#   return false
