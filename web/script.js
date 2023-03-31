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
        //type cast registration to ServiceWorkerRegistration
        await registration.showNotification(message, { body: body, sound:'assets/sounds/notification.mp3' },);
        // wait for 5 seconds
        await new Promise(resolve => setTimeout(resolve, 5000));
        // close the notification
        await registration.showNotification(message + " #delayed", { body: body, sound:'assets/sounds/notification.mp3' },);
    }
}