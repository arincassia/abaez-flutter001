#!/bin/bash

# URL del endpoint
URL="https://crudcrud.com/api/bbbdd94e1b264554b411c1a2d16b66cf/noticias"

# Función para lanzar una excepción
throw_exception() {
  echo "Excepción: Se recibió un error 4xx del servidor."
  exit 1
}

# Bucle para probar el endpoint
while true; do
  # Realizar la solicitud con curl
  RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

  # Verificar si el código de respuesta es un error 4xx
  if [[ $RESPONSE =~ ^4[0-9]{2}$ ]]; then
    echo "Error 4xx detectado: $RESPONSE"
    throw_exception
  fi

  # Imprimir el código de respuesta si no es un error 4xx
  echo "Respuesta del servidor: $RESPONSE"

  # Esperar 1 segundo antes de la siguiente solicitud
  sleep 1
done