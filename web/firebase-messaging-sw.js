importScripts('https://www.gstatic.com/firebasejs/10.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.0.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyDnZaFsHLJgF87cKqq0ccT90mXessNJtaY',
  authDomain: 'ipuc-pis-directory.firebaseapp.com',
  projectId: 'ipuc-pis-directory',
  storageBucket: 'ipuc-pis-directory.firebasestorage.app',
  messagingSenderId: '804660931161',
  appId: '1:804660931161:web:e60cef4256dc9a0dc79f48',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const title = payload.notification?.title ?? 'Directorio Pisarreal';
  const body  = payload.notification?.body  ?? '';
  self.registration.showNotification(title, {
    body,
    icon: '/icons/Icon-512.png',
    badge: '/icons/Icon-192.png',
    image: '/icons/Icon-512.png',
  });
});
