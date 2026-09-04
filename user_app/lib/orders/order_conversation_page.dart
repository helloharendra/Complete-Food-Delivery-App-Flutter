import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderConversationPage extends StatefulWidget {
  const OrderConversationPage({super.key, required this.orderId, required this.role});
  final String orderId;
  final String role;

  @override
  State<OrderConversationPage> createState() => _OrderConversationPageState();
}

class _OrderConversationPageState extends State<OrderConversationPage> {
  final _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  Future<void> _send({String? preset, String type = 'text'}) async {
    final user = FirebaseAuth.instance.currentUser;
    final text = (preset ?? _controller.text).trim();
    if (user == null || text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await FirebaseFirestore.instance.collection('orders').doc(widget.orderId).collection('messages').add({
        'senderId': user.uid,
        'senderRole': widget.role,
        'text': text,
        'type': type,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _controller.clear();
    } on FirebaseException catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر إرسال الرسالة: ${error.code}')));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text('محادثة الطلب', style: TextStyle(fontWeight: FontWeight.w900))),
      body: Column(children: [
        Expanded(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('orders').doc(widget.orderId).collection('messages').orderBy('createdAt', descending: true).limit(100).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return const Center(child: Text('تعذر تحميل المحادثة'));
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final messages = snapshot.data!.docs;
            if (messages.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(28), child: Text('ابدأ محادثة بخصوص الطلب. الرسائل ظاهرة فقط لأطراف الطلب.', textAlign: TextAlign.center)));
            return ListView.builder(reverse: true, padding: const EdgeInsets.all(14), itemCount: messages.length, itemBuilder: (_, index) {
              final data = messages[index].data();
              final mine = data['senderId'] == uid;
              final arrived = data['type'] == 'riderArrived';
              return Align(
                alignment: mine ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 310),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(color: arrived ? const Color(0xFFFFE8B5) : mine ? const Color(0xFFDCEFE6) : Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: const Color(0xFFDDE5E0))),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [if (arrived) ...[const Icon(Icons.location_on_rounded, size: 19, color: Color(0xFF9A5A00)), const SizedBox(width: 6)], Flexible(child: Text((data['text'] ?? '').toString(), style: const TextStyle(fontWeight: FontWeight.w700)))]),
                ),
              );
            });
          },
        )),
        SafeArea(top: false, child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Row(children: [
            Expanded(child: TextField(controller: _controller, minLines: 1, maxLines: 4, textInputAction: TextInputAction.newline, decoration: const InputDecoration(hintText: 'اكتب رسالة عن الطلب...', prefixIcon: Icon(Icons.chat_bubble_outline_rounded)))),
            const SizedBox(width: 8),
            IconButton.filled(onPressed: _sending ? null : _send, icon: _sending ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send_rounded)),
          ]),
        )),
      ]),
    );
  }
}
