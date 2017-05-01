# README

Primero que todo nuestra ~~super~~ app está en www.mrmeesbet.herokuapp.com 


Esteticamente corre bien en safari con un pc de 15 pulgadas  :sweat_smile:.


Hay seeds en el archivo seeds de la carpeta db, se corren con rails db:seed. Lamentablemente falla en un 10% de las ejecuciones por problemas en las keys.

Las validaciones de frontend están realizadas mediante el form de rails, las de backend en los modelos y las de base de datos en las migraciones.

Hicimos 3 scaffolds, users, user_bets y bets, en los 3 casos requeriamos de vistas controladores y modelos, por esto optamos hcaer scaffold en vez de otra cosa, aunque las vistas fueron cambiadas.



