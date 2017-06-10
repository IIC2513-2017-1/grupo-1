$(document).on('turbolinks:load', function () {
  var $tabs = $('.tablinks');
  $tabs.on('click', function(e){
    var $link = $(this);
    var $tab = $('.' + $link.data('tab'));

    $('.tab-content').each(function(){
      $(this).hide();
    });

    $tabs.each(function(){
      $(this).removeClass('active');
    });

    $link.addClass('active');
    $tab.show();
  });
});
