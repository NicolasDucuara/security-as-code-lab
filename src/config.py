"""Configuración de la aplicación cargada de forma segura desde el entorno."""

import os

# Se obtiene el token desde variables de entorno para evitar almacenar secretos en el código
APP_API_TOKEN = os.getenv("APP_API_TOKEN", "")
