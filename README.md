# abaez-flutter001
Este proyecto es parte del bootcamp de Flutter donde se implementa un CRUD (Crear, Leer, Actualizar, Eliminar) completo utilizando Dio para la conexión HTTP y Bloc para la gestión de estado.

## Tecnologías Utilizadas
- Flutter
- BLoC para gestión de estado
- Dio para comunicación con API
- Variables de entorno con flutter_dotenv

## Configuración de Variables de Entorno
Este proyecto utiliza un archivo `.env` para gestionar las variables de entorno. Sigue estos pasos para configurarlo:

1. Busca el archivo `.env.example` en la raíz del proyecto
2. Crea una copia de este archivo y renómbralo a `.env`
3. Actualiza los valores de las variables según tu entorno:
4. Guarda el archivo para que la aplicación pueda leer estas variables al iniciar

## Instrucciones de Configuración
1. Clona el repositorio
```bash
git clone https://https://github.com/arincassia/abaez-flutter001.git
```
3. Instala las dependencias
```bash
flutter clean
flutter pub get
```
4. Inicia la aplicación usando
```bash
flutter run
```
## Configuración para pruebas con CrudCrud
Si deseas probar el proyecto utilizando [CrudCrud](https://crudcrud.com/), sigue estos pasos:

1. Visita [CrudCrud](https://crudcrud.com/) para obtener un endpoint temporal gratuito
2. Actualiza la variable `NEWS_URL` en tu archivo `.env` con el endpoint proporcionado
3. Utiliza las siguientes estructuras JSON para tus operaciones CRUD:

### Estructura JSON para Noticias:
```json
{
  "titulo": "Título de la noticia",
  "descripcion": "Descripción detallada de la noticia",
  "categoria": "deportes",
  "fecha": "2025-05-05T12:00:00Z",
  "autor": "Nombre del Autor",
  "urlImagen": "https://picsum.photos/200/300"
}
```

### Estructura JSON para Categorias:
```json
{
  "nombre": "Nombre de la categoria",
  "descripcion": "Descripción de la categoria",
  "imagenUrl": "https://picsum.photos/seed/600/400"
}
```

### Endpoints de noticias:
- `GET /noticias`: Obtiene todas las noticias
- `POST /noticias`: Crea una nueva noticia
- `PUT /noticias/id`: Actualiza una noticia existente
- `DELETE /noticias/id`: Elimina una noticia

### Endpoints de categorias:
- `GET /categorias`: Obtiene todas las noticias
- `POST /categorias`: Crea una nueva noticia
- `PUT /categorias/id`: Actualiza una noticia existente
- `DELETE /categorias/id`: Elimina una noticia


## Estructura del Proyecto
- service: Implementación de servicios de API
- bloc: Archivos de implementación del patrón BLoC
- domain: Modelos de datos como `Noticia`
- views: Pantallas y componentes de UI
- data: Capa de datos y repositorios para acceso a API
- constants.dart: Constantes y configuración de la aplicación

## Demostración y Pruebas
- [Smoke Test](https://docs.google.com/spreadsheets/d/1RPSO2G2eOtt2C2kwVC7xKcPqA8LmgTWUci95anH5X94/edit?usp=sharing) - Enlace al smoke test
- [Video Demostrativo](https://drive.google.com/file/d/1o8uOo4_xQsUOSrs90BlFEil2iWGEIltw/view?usp=sharing) - Video mostrando la funcionalidad de la aplicación

## Colaboradores
- Este proyecto fue desarrollado como parte de un bootcamp de Flutter
