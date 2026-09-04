'use strict';

const {onDocumentCreated, onDocumentUpdated} = require('firebase-functions/v2/firestore');
const {initializeApp} = require('firebase-admin/app');
const {getFirestore, FieldValue} = require('firebase-admin/firestore');
const {getMessaging} = require('firebase-admin/messaging');

initializeApp();
const db = getFirestore();

async function tokensFor(uid) {
  if (!uid) return [];
  const snap = await db.collection('deviceTokens').doc(uid).collection('tokens').where('active', '==', true).get();
  return snap.docs.map((doc) => doc.get('token')).filter(Boolean);
}

async function notify(recipients, title, body, data = {}) {
  const unique = [...new Set(recipients.filter(Boolean))];
  await Promise.all(unique.map((recipientId) => db.collection('notifications').add({
    recipientId, title, body, data, createdAt: FieldValue.serverTimestamp(), readAt: null,
  })));
  const tokens = (await Promise.all(unique.map(tokensFor))).flat().slice(0, 500);
  if (!tokens.length) return;
  const response = await getMessaging().sendEachForMulticast({
    tokens,
    notification: {title, body},
    data: Object.fromEntries(Object.entries(data).map(([key, value]) => [key, String(value)])),
    android: {priority: 'high', notification: {sound: 'default'}},
  });
  const invalid = [];
  response.responses.forEach((result, index) => {
    if (!result.success && ['messaging/registration-token-not-registered', 'messaging/invalid-registration-token'].includes(result.error?.code)) invalid.push(tokens[index]);
  });
  if (invalid.length) {
    const group = db.batch();
    for (const uid of unique) {
      const snap = await db.collection('deviceTokens').doc(uid).collection('tokens').where('token', 'in', invalid.slice(0, 30)).get();
      snap.docs.forEach((doc) => group.update(doc.ref, {active: false, updatedAt: FieldValue.serverTimestamp()}));
    }
    await group.commit();
  }
}

exports.onOrderCreated = onDocumentCreated({document: 'orders/{orderId}', region: 'me-central1'}, async (event) => {
  const order = event.data?.data();
  if (!order) return;
  await notify([order.sellerUID], 'طلب جديد وصل لمتجرك', `طلب جديد من ${order.customerName || 'عميل ديرب'} بقيمة ${order.total || order.totolAmmount || 0} ج.م`, {type: 'newOrder', orderId: event.params.orderId});
});

exports.onOrderUpdated = onDocumentUpdated({document: 'orders/{orderId}', region: 'me-central1'}, async (event) => {
  const before = event.data?.before.data();
  const after = event.data?.after.data();
  if (!before || !after || before.status === after.status) return;
  const orderId = event.params.orderId;
  if (after.status === 'readyForPickup') {
    const riders = await db.collection('riders').where('status', 'in', ['approved', 'Approved']).where('available', '==', true).limit(200).get();
    await notify(riders.docs.map((doc) => doc.id), 'طلب جاهز للتوصيل', `طلب جاهز من ${after.storeName || 'متجر ديرب'}`, {type: 'deliveryAvailable', orderId});
  }
  const labels = {acceptedByMerchant: 'تم قبول طلبك', preparing: 'طلبك جاري تجهيزه', readyForPickup: 'طلبك جاهز للمندوب', pickedUpByRider: 'استلم المندوب طلبك', onTheWay: 'طلبك في الطريق', delivered: 'تم تسليم طلبك', rejected: 'المتجر اعتذر عن الطلب', cancelled: 'تم إلغاء الطلب'};
  if (labels[after.status]) await notify([after.orderedBy], labels[after.status], `طلبك من ${after.storeName || 'متجر ديرب'}: ${labels[after.status]}`, {type: 'orderStatus', orderId, status: after.status});
  if (after.riderUID && before.riderUID !== after.riderUID) await notify([after.riderUID], 'تم إسناد طلب إليك', `طلب من ${after.storeName || 'متجر ديرب'}`, {type: 'deliveryAssigned', orderId});
});

exports.onOrderMessageCreated = onDocumentCreated({document: 'orders/{orderId}/messages/{messageId}', region: 'me-central1'}, async (event) => {
  const message = event.data?.data();
  if (!message) return;
  const order = (await db.collection('orders').doc(event.params.orderId).get()).data();
  if (!order) return;
  const recipients = [order.orderedBy, order.sellerUID, order.riderUID].filter((uid) => uid && uid !== message.senderId);
  const arrived = message.type === 'riderArrived';
  await notify(recipients, arrived ? 'المندوب وصل' : 'رسالة جديدة بخصوص الطلب', arrived ? 'المندوب وصل لمكان التسليم' : String(message.text).slice(0, 120), {type: arrived ? 'riderArrived' : 'orderMessage', orderId: event.params.orderId});
});
