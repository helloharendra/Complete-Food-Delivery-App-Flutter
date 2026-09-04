import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderConversationPage extends StatefulWidget {
  const OrderConversationPage({super.key, required this.orderId}); final String orderId;
  @override State<OrderConversationPage> createState() => _State();
}
class _State extends State<OrderConversationPage> {
  final input=TextEditingController(); bool sending=false;
  @override void dispose(){input.dispose();super.dispose();}
  Future<void> send({String? preset,String type='text'}) async { final u=FirebaseAuth.instance.currentUser; final text=(preset??input.text).trim(); if(u==null||text.isEmpty||sending)return; setState(()=>sending=true); try{await FirebaseFirestore.instance.collection('orders').doc(widget.orderId).collection('messages').add({'senderId':u.uid,'senderRole':'rider','text':text,'type':type,'createdAt':FieldValue.serverTimestamp()});input.clear();}on FirebaseException catch(e){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('تعذر الإرسال: ${e.code}')));}finally{if(mounted)setState(()=>sending=false);}}
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('التواصل مع العميل',style:TextStyle(fontWeight:FontWeight.w900))),body:Column(children:[
    Padding(padding:const EdgeInsets.fromLTRB(12,8,12,0),child:SizedBox(width:double.infinity,child:FilledButton.tonalIcon(onPressed:sending?null:()=>send(preset:'المندوب وصل لمكان التسليم',type:'riderArrived'),icon:const Icon(Icons.location_on_rounded),label:const Text('إبلاغ العميل: وصلت')))),
    Expanded(child:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:FirebaseFirestore.instance.collection('orders').doc(widget.orderId).collection('messages').orderBy('createdAt',descending:true).limit(100).snapshots(),builder:(_,snap){if(snap.hasError)return const Center(child:Text('تعذر تحميل المحادثة'));if(!snap.hasData)return const Center(child:CircularProgressIndicator());if(snap.data!.docs.isEmpty)return const Center(child:Text('ابدأ التواصل مع العميل'));final uid=FirebaseAuth.instance.currentUser?.uid;return ListView.builder(reverse:true,padding:const EdgeInsets.all(14),itemCount:snap.data!.docs.length,itemBuilder:(_,i){final d=snap.data!.docs[i].data();final mine=d['senderId']==uid;return Align(alignment:mine?AlignmentDirectional.centerStart:AlignmentDirectional.centerEnd,child:Container(margin:const EdgeInsets.symmetric(vertical:4),padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:d['type']=='riderArrived'?const Color(0xFFFFE8B5):mine?const Color(0xFFDCEFE6):Colors.white,borderRadius:BorderRadius.circular(16),border:Border.all(color:const Color(0xFFDDE5E0))),child:Text((d['text']??'').toString(),style:const TextStyle(fontWeight:FontWeight.w700))));});})),
    SafeArea(top:false,child:Padding(padding:const EdgeInsets.all(12),child:Row(children:[Expanded(child:TextField(controller:input,decoration:const InputDecoration(hintText:'اكتب رسالة للعميل...'))),const SizedBox(width:8),IconButton.filled(onPressed:sending?null:send,icon:const Icon(Icons.send_rounded))])))
  ]));
}
