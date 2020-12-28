const functions = require('firebase-functions')
const admin = require('firebase-admin')

admin.initializeApp()

// Requisitions
exports.createRequisition = functions.firestore
    .document('requisitions/{requisitionId}')
    .onCreate((snap, context) => {
        admin.messaging().sendToTopic('requisition_create', {
            notification: {
                title: 'Nova requisição de ' + snap.data().nameUserRequested,
                body: 'Descrição: ' + snap.data().description,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        })
    })

exports.updateRequisition = functions.firestore
    .document('requisitions/{requisitionId}')
    .onUpdate((snap, context) => {
        console.log(snap.data());
        admin.messaging().sendToTopic('requisition_update', {
            notification: {
                title: 'Status de Requisição Alterada para ' + snap.data().status,
                body: 'Descrição: ' + snap.data().description,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        })
    })

// Users
exports.createUser = functions.firestore
    .document('users/{userId}')
    .onCreate((snap, context) => {
        admin.messaging().sendToTopic('user_create', {
            notification: {
                title: 'Usuário ' + snap.data().name + ' cadastrado',
                body: 'Ative o novo usuário e associe-o com algum departamento...',
                clickAction: 'FLUTTER_NOTIFICATION_CLICK',
            }
        })

    });