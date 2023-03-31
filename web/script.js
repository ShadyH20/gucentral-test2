var registration;
var granted = false;

async function requestNotPermission() {
    registration = await navigator.serviceWorker.register('serviceworker.js',{scope: './'});
    const result = await window.Notification.requestPermission();
    if(result === 'granted') {
        granted = true;
    }
    return granted;

    
}

async function showNotification(message, body) {
    if (granted) {
        await registration.showNotification(message, { body: body },);
    }
}