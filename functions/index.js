const { onDocumentCreated } = require('firebase-functions/v2/firestore');
const { initializeApp } = require('firebase-admin/app');
const { getMessaging } = require('firebase-admin/messaging');

initializeApp();

exports.notifyNewMember = onDocumentCreated('members/{memberId}', async (event) => {
  const member = event.data.data();
  const name = member?.name ?? 'Un hermano';

  await getMessaging().send({
    topic: 'directorio_ipuc',
    notification: {
      title: '¡Nuevo hermano en el directorio!',
      body: `${name} acaba de unirse a la comunidad.`,
    },
    android: {
      notification: {
        channelId: 'ipuc_directorio',
        sound: 'default',
      },
    },
    apns: {
      payload: {
        aps: { sound: 'default' },
      },
    },
  });
});
