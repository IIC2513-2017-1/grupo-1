// Ajax en el carrito de apuesta del indice de bets
$(document).on('turbolinks:load', function () {
  $bets = $(".bet-selection");
  $bets_list = $(".bets-list");
  $monto = $("#amount");
  var $previous;
  var $previous_mul;
  $monto.on('change', function() {
    $.getJSON("/set_amount", {
      amount: $('#amount').val(),
      previous_mul: $('#multiplicator').text()
    }, function( data ) {
      $('#wining').text("Ganancia: " + data.wining);
    });
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
        $('#wining').text("Ganancia: " + data.wining);
        $('#multiplicator').text("Multiplicador: " + data.multiplicator);
      }
    });
  });
});
