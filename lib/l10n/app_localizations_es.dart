// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Directorio IPUC';

  @override
  String get appTagline => 'Conectando nuestra comunidad';

  @override
  String get btnSave => 'Guardar';

  @override
  String get btnContinue => 'Continuar';

  @override
  String get btnCancel => 'Cancelar';

  @override
  String get btnDelete => 'Eliminar';

  @override
  String get btnEdit => 'EDITAR';

  @override
  String get btnAdd => 'Agregar';

  @override
  String get btnSignIn => 'Iniciar sesión';

  @override
  String get btnSignUp => 'Regístrate';

  @override
  String get btnNotNow => 'Ahora no';

  @override
  String get btnCreateProfile => 'Crear mi perfil';

  @override
  String get btnEditProfile => 'Editar mi perfil';

  @override
  String get btnDeleteProfile => 'Eliminar mi perfil';

  @override
  String get btnActivateNotifications => 'Activar notificaciones';

  @override
  String get btnAddService => 'Agregar servicio';

  @override
  String get btnContactWhatsApp => 'Contactar por WhatsApp';

  @override
  String get btnChangePhoto => 'CAMBIAR FOTO';

  @override
  String get btnUploadPhoto => 'SUBIR FOTO';

  @override
  String get btnUploading => 'SUBIENDO...';

  @override
  String get dirTitle => 'Directorio';

  @override
  String get dirSubtitle => 'Hermanos.';

  @override
  String get dirChurch => 'IGLESIA PENTECOSTAL UNIDA DE COLOMBIA';

  @override
  String get dirChurchShort => 'IPUC Pisarreal';

  @override
  String get dirQuoteEmpty => '«Un Señor, una fe, un bautismo.»';

  @override
  String dirQuoteWithCount(int count) {
    return '«Un Señor, una fe, un bautismo.» — $count hermanos ofreciendo su trabajo.';
  }

  @override
  String get dirSearch => 'Busca por nombre o servicio...';

  @override
  String get dirAll => 'Todos';

  @override
  String get catAll => 'Todos';

  @override
  String get catEmpresa => 'Empresa';

  @override
  String get catEmprendimiento => 'Emprendimiento';

  @override
  String get catArte => 'Arte';

  @override
  String get catServicio => 'Servicio';

  @override
  String get dirNoResults => 'Sin resultados';

  @override
  String get dirNoResultsSubtitle =>
      'Intenta con otro nombre o cambia la categoría.';

  @override
  String get dirBeFirst => 'Sé el primero';

  @override
  String get dirEmptySubtitle =>
      'El directorio está vacío. Únete y comparte tus servicios con la comunidad.';

  @override
  String get dirErrorLoad => 'No se pudo cargar el directorio';

  @override
  String get profilePhone => 'TELÉFONO';

  @override
  String get profilePhoneVerified => 'TELÉFONO · VERIFICADO';

  @override
  String get profileWhatTheyOffer => 'LO QUE OFRECE';

  @override
  String get profileWhatYouOffer => 'LO QUE OFRECES';

  @override
  String get profileViews => 'Vistas esta\nsemana';

  @override
  String get profileContacts => 'Contactos por\nWhatsApp';

  @override
  String get profileActiveServices => 'Servicios\nactivos';

  @override
  String get profilePublished => 'PUBLICADO';

  @override
  String get profilePublishedVerified => 'PUBLICADO · VERIFICADO';

  @override
  String get profileUnderReview => 'EN REVISIÓN';

  @override
  String get profileVerified => 'VERIFICADO';

  @override
  String get profileNew => 'Nuevo';

  @override
  String get profileMyProfile => 'MI PERFIL';

  @override
  String get profileCategory => 'CATEGORÍA';

  @override
  String get profileServiceLabel => 'NEGOCIO O SERVICIO';

  @override
  String get profileServiceHint => 'Ej: Repostería Casera Dulce Maná';

  @override
  String get profileBioLabel => 'DESCRIBE LO QUE OFRECES';

  @override
  String get profileServicesLabel => 'TUS SERVICIOS';

  @override
  String get profileVisibleLabel => 'Visible en el directorio';

  @override
  String get authWelcomeTitle => 'Bienvenido de vuelta';

  @override
  String get authSignInToEdit => 'Inicia sesión para editar tu perfil.';

  @override
  String get authSignInToView => 'Inicia sesión para ver tu perfil';

  @override
  String get authEmailLabel => 'TU CORREO';

  @override
  String get authPasswordLabel => 'CONTRASEÑA';

  @override
  String get authEmailHint => 'correo@ejemplo.com';

  @override
  String get authPasswordHint => 'Tu contraseña';

  @override
  String get authMinPassword => 'Mín. 8 caracteres, 1 mayúscula y 1 número';

  @override
  String get authNoProfile => '¿No tienes perfil?';

  @override
  String get authSignInPrompt => 'Inicia sesión';

  @override
  String get authForgotPasswordPrompt => '¿Olvidaste tu contraseña?';

  @override
  String get forgotPasswordTitle => 'Recupera tu contraseña';

  @override
  String get forgotPasswordSubtitle =>
      'Ingresa tu correo y te enviaremos un enlace para restablecerla.';

  @override
  String get forgotPasswordSuccessTitle => 'Revisa tu correo';

  @override
  String get forgotPasswordSuccessBody =>
      'Si el correo existe en nuestro sistema, te enviamos un enlace para restablecer tu contraseña.';

  @override
  String get btnSendResetLink => 'Enviar enlace';

  @override
  String get btnBackToLogin => 'Volver a iniciar sesión';

  @override
  String get regNameLabel => 'TU NOMBRE';

  @override
  String get regNameHint => 'Nombre completo';

  @override
  String get regOfferQuestion => '¿QUÉ QUIERES HACER?';

  @override
  String get regOfferService => 'Ofrecer un servicio';

  @override
  String get regOfferServiceDesc =>
      'Publica lo que haces para que la comunidad te encuentre.';

  @override
  String get regSearchOnly => 'Solo buscar y contactar';

  @override
  String get regSearchOnlyDesc =>
      'Únete para encontrar y contactar a otros hermanos.';

  @override
  String get regPhoneLabel => 'TU NÚMERO DE WHATSAPP';

  @override
  String get regCategoryQuestion => '¿EN QUÉ CATEGORÍA ENCAJAS?';

  @override
  String get regServiceHint => 'Ej: Tortas de cumpleaños';

  @override
  String get regBioHint => 'Cuéntale a la comunidad qué haces...';

  @override
  String get regNoServices => 'Aún no has agregado servicios.';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get settingsAppearance => 'APARIENCIA';

  @override
  String get settingsNotifications => 'NOTIFICACIONES';

  @override
  String get settingsAccount => 'CUENTA';

  @override
  String get settingsThemeAuto => 'Automático';

  @override
  String get settingsThemeAutoDesc => 'Sigue el sistema de tu teléfono';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsNotifyNewMembers => 'Avisarme de nuevos hermanos';

  @override
  String get settingsNotifyContacts => 'Contactos a mi perfil';

  @override
  String get settingsNotifyContactsDesc =>
      'Apágalo si no quieres recibir contactos por ahora.';

  @override
  String get settingsMyProfile => 'Mi perfil';

  @override
  String get settingsHelp => 'Ayuda y soporte';

  @override
  String get settingsPrivacy => 'Política de privacidad';

  @override
  String get errOpenPrivacy => 'No se pudo abrir la política de privacidad.';

  @override
  String get settingsHelpMessage =>
      'Hola, necesito ayuda con el Directorio IPUC Pisarreal 🙏';

  @override
  String get settingsSignOut => 'Cerrar sesión';

  @override
  String get settingsLanguage => 'IDIOMA';

  @override
  String get settingsLangSpanish => 'Español';

  @override
  String get settingsLangEnglish => 'Inglés';

  @override
  String get settingsFooter =>
      'Directorio Hermanos · v1.0\nIglesia Pentecostal Unida de Colombia\nPisarreal - Los Patios';

  @override
  String get notifDialogTitle => 'Mantente al día';

  @override
  String get notifDialogBody =>
      'Activa las notificaciones para saber cuando un nuevo hermano se une al directorio.';

  @override
  String get notifNewMember => '¡Nuevo hermano en el directorio!';

  @override
  String get notifNewMemberBody =>
      'Únete al directorio y comparte tus servicios con la comunidad.';

  @override
  String get authDialogTitle => 'Inicia sesión';

  @override
  String get authDialogBody =>
      'Debes iniciar sesión para ver la información de contacto.';

  @override
  String get deleteDialogTitle => '¿Eliminar perfil?';

  @override
  String get deleteDialogBody => 'Esta acción no se puede deshacer.';

  @override
  String get deleteSuccessTitle => 'Perfil eliminado';

  @override
  String get deleteSuccessBody =>
      'Tu perfil ha sido eliminado de la comunidad.';

  @override
  String get successSaved => 'Cambios guardados.';

  @override
  String get successSignedOut => 'Sesión cerrada.';

  @override
  String get successProfileCreated =>
      '¡Perfil creado! Bienvenido al directorio.';

  @override
  String get splashTagline => 'Conectando nuestra comunidad';

  @override
  String get errOpenWhatsApp => 'No se pudo abrir WhatsApp.';

  @override
  String get errOpenDialer => 'No se pudo abrir el marcador.';

  @override
  String get errLoadProfile => 'No se pudo cargar tu perfil.';

  @override
  String get errLoadDirectory => 'No se pudo cargar el directorio';

  @override
  String get errCreateProfile =>
      'No se pudo crear el perfil. Intenta de nuevo.';

  @override
  String get errDeleteProfile =>
      'No se pudo eliminar el perfil. Intenta de nuevo.';

  @override
  String get errReauthRequired =>
      'Por seguridad, cierra sesión, vuelve a iniciar sesión e intenta de nuevo.';

  @override
  String get errSave => 'No se pudo guardar.';

  @override
  String get errSignIn => 'No se pudo iniciar sesión. Intenta de nuevo.';

  @override
  String get errUploadPhoto => 'No se pudo subir la foto. Intenta de nuevo.';

  @override
  String get errSaveChanges =>
      'No se pudieron guardar los cambios. Intenta de nuevo.';

  @override
  String get errNoConnection =>
      'Sin conexión. Revisa tu internet e intenta de nuevo.';

  @override
  String get errEmailTaken => 'Ese correo ya está registrado. Inicia sesión.';

  @override
  String get errInvalidEmail => 'El correo no es válido.';

  @override
  String get errWeakPassword =>
      'La contraseña debe tener mínimo 8 caracteres, una mayúscula y un número.';

  @override
  String get errWrongCredentials => 'Correo o contraseña incorrectos.';

  @override
  String get errUserNotFound => 'No existe una cuenta con ese correo.';

  @override
  String get errPhoneTaken =>
      'Ese número ya está registrado. Si es tuyo, inicia sesión.';

  @override
  String get errGeneric => 'No se pudo completar. Intenta más tarde.';

  @override
  String get errDeleteGeneric => 'No se pudo eliminar.';
}
