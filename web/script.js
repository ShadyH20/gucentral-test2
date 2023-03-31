async function showNotification(message) {
    const registration = await navigator.serviceWorker.register('serviceworker.js',{scope: './'});

    const result = await window.Notification.requestPermission();
    if (result === 'granted') {
        await registration.showNotification(message, { body: 'This is a notification' });
    }
    return result;
}