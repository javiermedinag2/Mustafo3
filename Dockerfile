FROM python:3.12-slim

WORKDIR /app

# Crear usuario no-root para ejecutar la aplicación
RUN useradd -m -u 1000 appuser

# Instalar dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar aplicación
COPY . .

# Cambiar propietario de los archivos
RUN chown -R appuser:appuser /app

# Cambiar a usuario no-root
USER appuser

ENV FLASK_APP=app.py
EXPOSE 5000

CMD ["flask", "run", "--host=0.0.0.0"]
