$(function(){
  $('.delete').on("click",function(){
    var li = $(this).parent()
    if (!confirm('sure?')) {
      return;
    }
    $.post('/destroy',{
      id: li.data('id'),
      _csrf: li.data('token')
    }, function(){
      li.fadeOut(300)
    })
  })
})