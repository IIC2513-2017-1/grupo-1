$(document).on('turbolinks:load', function () {

  // TABS
  var $tabs = $('.tablinks');
  $tabs.on('click', function(e){
    $(".alert").remove();
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

  // MODAL
  $(".modal-trigger").click(function(e){
    e.preventDefault();
    dataModal = $(this).attr("data-modal");
    $("." + dataModal).css({"display":"block"});
  });

  $(".close-modal, .modal-sandbox").click(function(){
    $(".modal").css({"display":"none"});
  });
});
