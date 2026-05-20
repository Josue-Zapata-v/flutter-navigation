import '../models/faq_item.dart';

const List<FaqItem> faqData = [
  FaqItem(
    question: '¿Cómo registro un nuevo alumno?',
    answer:
        'Dirígete al menú lateral y selecciona "Registrar Alumno". '
        'Completa el formulario con el nombre, apellidos y fecha de nacimiento, '
        'luego presiona el botón "Grabar" para guardar al alumno en el sistema.',
  ),
  FaqItem(
    question: '¿Cómo puedo ver la lista de alumnos registrados?',
    answer:
        'Desde el menú lateral selecciona "Listar Alumnos". '
        'Ahí encontrarás todos los alumnos registrados durante la sesión actual, '
        'con su nombre completo, fecha de nacimiento y edad calculada automáticamente.',
  ),
  FaqItem(
    question: '¿Puedo eliminar un alumno de la lista?',
    answer:
        'Sí. En la pantalla "Listar Alumnos", desliza la tarjeta del alumno '
        'hacia la izquierda o presiona el ícono de eliminar para removerlo '
        'del registro de la sesión actual.',
  ),
  FaqItem(
    question: '¿Los datos se guardan al cerrar la aplicación?',
    answer:
        'Actualmente los datos se mantienen en memoria durante la sesión activa. '
        'Al cerrar la sesión o la aplicación, los registros ingresados se perderán. '
        'En versiones futuras se implementará almacenamiento persistente en base de datos.',
  ),
  FaqItem(
    question: '¿Cuáles son las credenciales de acceso?',
    answer:
        'El sistema cuenta con un usuario administrador por defecto: '
        'Usuario: admin | Contraseña: 1234. '
        'Por seguridad, se recomienda no compartir estas credenciales.',
  ),
  FaqItem(
    question: '¿Cómo cierro sesión correctamente?',
    answer:
        'Para cerrar sesión de forma segura, dirígete al menú lateral y '
        'selecciona la opción "Cerrar Sesión". Serás redirigido automáticamente '
        'a la pantalla de inicio de sesión.',
  ),
  FaqItem(
    question: '¿Qué información se puede registrar por alumno?',
    answer:
        'Por cada alumno se registra: nombre(s), apellidos y fecha de nacimiento. '
        'El sistema calcula automáticamente la edad del alumno a partir de '
        'la fecha de nacimiento ingresada.',
  ),
];