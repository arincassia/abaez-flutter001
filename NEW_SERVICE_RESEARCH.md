# Servicio API RESTful: Beeceptor

## Nombre del servicio
Beeceptor

## URL base y endpoints disponibles

**URL base:**

https://<nombre-del-endpoint>.beeceptor.com

**Endpoints disponibles (ejemplo):**
- `/news`
- `/comments`
- `/categories`
- `/preferences`

> Puedes definir cualquier ruta arbitraria. Beeceptor actúa como un interceptor o mock server que acepta estructuras JSON personalizadas.

---

## Requerimientos de API Key y cómo obtenerla

### Protección por API Key (opcional):

Beeceptor permite proteger endpoints mediante una **API Key personalizada**.

### Pasos para configurarla:
1. Ve a [https://beeceptor.com](https://beeceptor.com) y crea una cuenta gratuita.
2. Crea un nuevo endpoint con un nombre personalizado.
3. En la configuración del endpoint, habilita la autenticación con API Key.
4. Define una clave (por ejemplo: `X-Api-Key: my-secret-key`) que debe incluirse en todas las peticiones.

**Ejemplo de cabecera:**
```http
X-Api-Key: my-secret-key
```

**Soporte para paginación**
Beeceptor no tiene paginación incorporada.

Como es un servicio de mocking y no almacena datos permanentemente, debes simular la paginación desde el cliente o manejar los parámetros manualmente.

Puedes enviar parámetros como:
GET /news?limit=5&offset=10

**Ejemplo de solicitud GET y respuesta JSON**
GET https://miapi.beeceptor.com/news
X-Api-Key: my-secret-key
Content-Type: application/json

Respuesta JSON (simulada)
[
  {
    "id": 1,
    "titulo": "Noticia destacada",
    "contenido": "Contenido de la noticia destacada.",
    "fecha": "2025-05-06"
  },
  {
    "id": 2,
    "titulo": "Segunda noticia",
    "contenido": "Contenido de la segunda noticia.",
    "fecha": "2025-05-05"
  }
]