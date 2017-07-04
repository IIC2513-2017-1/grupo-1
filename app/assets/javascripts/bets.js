// Ajax en el carrito de apuesta del indice de bets
$(document).on('turbolinks:load', function () {
  $bets = $(".bet-selection");
  $bets_list = $(".bets-list");
  $monto = $("#amount");
  var $previous;
  var $previous_mul;
  $monto.on('change', function() {
    $('#wining').text("Ganancia: " + (parseFloat($('#multiplicator').text().split(" ")[1]) * $('#amount').val()).toFixed(2) );
  });
  $bets.on('focus', function () {
        // Store the current value on focus and on change
        $previous = $(this).val();
        $previous_mul = $('#multiplicator').text();
    }).on('change', function () {
    $.getJSON( "/add_bet",
    {
      bet_id: $(this).attr("name"),
      competitor: $(this).val(),
      previous: $previous,
      previous_mul: $previous_mul,
      amount: $('#amount').val()
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
        $('#wining').text("Ganancia: " + parseFloat(data.wining).toFixed(2));
        $('#multiplicator').text("Multiplicador: " + parseFloat(data.multiplicator).toFixed(2));
      }
    });
  });
});
