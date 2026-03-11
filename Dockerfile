# Para crerar una imagen de Docker para una aplicación Flask, puedes usar el siguiente Dockerfile. Este archivo define la configuración necesaria para construir la imagen y ejecutar la aplicación Flask dentro de un contenedor Docker.
FROM python:3.9-slim-buster
# Establece el directorio de trabajo dentro del contenedor. En este directorio se copiarán los archivos de la aplicación y se ejecutará el comando para iniciar la aplicación Flask.
WORKDIR /app
# Copia el archivo requirements.txt al directorio de trabajo en el contenedor. Este archivo contiene las dependencias necesarias para la aplicación Flask. Luego, se ejecuta el comando pip install para instalar estas dependencias dentro del contenedor.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# Copia todos los archivos de la aplicación Flask al directorio de trabajo en el contenedor. Esto incluye el archivo app.py y cualquier otro archivo necesario para la aplicación.
COPY . .
#Establece la variable de entorno FLASK_APP para indicar el archivo principal de la aplicación Flask. Luego, se expone el puerto 5000, que es el puerto predeterminado en el que Flask se ejecuta. Finalmente, se define el comando para iniciar la aplicación Flask cuando se ejecute el contenedor.
ENV FLASK_APP=app.py
#
EXPOSE 5000
# El comando CMD se utiliza para especificar el comando que se ejecutará cuando se inicie el contenedor. En este caso, se ejecuta el comando "flask run" para iniciar la aplicación Flask, y se especifica que la aplicación debe escuchar en todas las interfaces de red (
CMD ["flask", "run", "--host=0.0.0.0"]