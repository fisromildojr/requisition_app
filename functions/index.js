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
    .onUpdate((change, context) => {
        admin.messaging().sendToTopic('requisition_update_' + change.after.data().idUserRequested, {
            notification: {
                title: 'Status: ' + change.after.data().status + ' por ' + change.after.data().solvedByName,
                body: 'Descrição: ' + change.after.data().description,
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