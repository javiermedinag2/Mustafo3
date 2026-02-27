from pymongo import MongoClient #Librería de MongoDB para Python 
from flask import Flask #Librería de Flask para crear aplicaciones web y renderizar plantillas HTML 
app = Flask(__name__) #Creación de una instancia de la aplicación Flask  
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

@app.route('/', methods=['GET'])
def index():
    return "Bienvenido a la Biblioteca", 200
@app.route('/libros', methods=['GET'])
def libros():
    libros_list = "<H1>Libros disponibles:</H1>\n"
    for L in Lista:
        libros_list += f"<p>{L['title']} - {L['author']}</p>\n"
    return libros_list, 200

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000) #Inicia la aplicación Flask en modo de depuración, lo que permite ver mensajes de error detallados en caso de que ocurra algún problema durante la ejecución de la aplicación.

