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
    $("." + dataModal).show();
  });

  $(".close-modal, .modal-sandbox").click(function(){
    $(".modal").hide();
  });

  // DINERIN ajax
  var $money_manage = $('.user-money-manage');
  $money_manage.on('ajax:success', function (e, data) {
    $(".alert").remove();
    if (data.money >= 0) {
      $(".dinerin").text(data.money);
    } else {
      $(".title-header").append("<div class='alert alert-alert'>No se pudo actualizar el dinerin</div>")
    }
    $(".modal").hide();
    $('input[type="number"]').val("");
  }).on('ajax:error', function (e, data) {
    console.log(data);
  });
});
