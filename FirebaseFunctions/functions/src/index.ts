import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

export const createUser = functions.auth.user().onCreate((user) => {
    return admin.firestore().collection('users').doc(user.uid).create({
        'Role': 'user',
        'RegisterDate': Date.now(),
        'SelectedCharacter': 'dJRKyr9CJeZtIg47beK1'
    })
});