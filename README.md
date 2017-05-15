# README

Primero que todo nuestra ~~super~~ app está en mrmeesbet.herokuapp.com 

Esteticamente corre bien en safari con un pc de 15 pulgadas  :sweat_smile:.

Hay seeds en el archivo seeds de la carpeta db, se corren con rails db:seed. En estas esta el usuario admin con mail j123@uc.cl y password 12345678 para ingresar a la aplicacíon, ademas cuenta con amigos y historial de apuestas.

Para el termino de apuestas se revisan la fecha de inicio, pudiendo acceder y apostar solo las que aun no comienzan. Para las apuestas de la pagina actualmente se genera un resultado aleatorio, actualizandose para cada usuario si es que gano o no. Por otro lado, para las apuestas de los usuarios, implementamos que tuviera un atributo resultado, y que le lleguen las notificaciones a los admin, pero no alcanzamos a implementar que los admin decidan el ganador aún.

Por ultimo, se nos olvido sacar las acciones y rutas de new, edit, y update del controlador de bets (apuestas de pagina), ya que no seran nesesarias porque las bets se implementaran via API. Actualmente se puede entrar poniendo los path en el buscador del browser.





