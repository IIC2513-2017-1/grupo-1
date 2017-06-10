// Ajax on bet_list
$(document).on('turbolinks:load', function () {
   var $bets;
   if (($bets = $('.meesbets-content')).length) {
     $bets.on('ajax:success', function (e, data) {
       var $button;
       $(".alert").remove();
       if (data.bet_id && (data.result == 'success')) {
         $(".meesbet" + data.bet_id).remove();
       } else {
         $(".title-header").append("<div class='alert alert-alert'>No se pudo aceptar la apuesta</div>")
       }
     }).on('ajax:error', function (e, data) {
       console.log(data);
     });
   }
 });
