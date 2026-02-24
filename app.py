from pymongo import MongoClient #Librería de MongoDB para Python 
Cliente = MongoClient('mongodb://root:root@localhost:27017/') 
#Conexión a la base de datos MongoDB utilizando el cliente de MongoDB. 
#Se especifica la URL de conexión, que incluye el nombre de usuario, la contraseña y la dirección del servidor.
db = Cliente.Biblioteca
#Acceso a la base de datos "Biblioteca" a través del cliente de MongoDB.
Libros = db.Libros
#Acceso a la colección "Libros" dentro de la base de datos "Biblioteca".
Lista = list(Libros.find())
#Se realiza una consulta a la colección "Libros" utilizando el método find(), que devuelve un cursor con todos los documentos de la colección. 
#Luego, se convierte el cursor en una lista utilizando la función list(), lo que permite iterar sobre los documentos de la colección de manera más sencilla.
for L in Lista:
    print(L['title'],"-", L['author'])
