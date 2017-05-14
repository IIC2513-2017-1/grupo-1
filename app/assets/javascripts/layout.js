window.onclick = function(e) {
  if (!e.target.matches('.dropbtn')) {
    const myDropdown = $("#myDropdown");
      if (myDropdown.hasClass('show')) {
        myDropdown.removeClass('show');
      }
  } else if (e.target.matches('.dropbtn')) {
    $("#myDropdown").toggleClass("show");
  }
}
