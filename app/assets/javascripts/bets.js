// Ajax en el carrito de apuesta del indice de bets
$(document).on('turbolinks:load', function () {
  $bets = $(".bet-selection");
  $bets_list = $(".bets-list");
  $bets.on('change', function () {
    $.getJSON( "/add_bet",
    {
      bet_id: $(this).attr("name"),
      competitor: $(this).val()
    }, function( data ) {
      if (data.bet_id) {
        if (data.delete == "false") {
          if ($(".bet-" + data.bet_id).length) {
            $(".bet-" + data.bet_id).text(data.bet_id + " - " + data.competitor);
          } else {
            $bets_list.append("<p class='bet-" + data.bet_id + "'>" + data.bet_id + "  -  " + data.competitor + "</p>");
          }
        } else {
          $(".bet-" + data.bet_id).remove();
        }
      }
    });
  });
});
