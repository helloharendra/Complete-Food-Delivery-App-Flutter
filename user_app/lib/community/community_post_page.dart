import 'package:dierb_core/dierb_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/firestore_dierb_repositories.dart';

class CommunityPostPage extends StatefulWidget {
  const CommunityPostPage({super.key, required this.post, required this.repository});
  final CommunityPost post;
  final FirestoreCommunityRepository repository;
  @override State<CommunityPostPage> createState() => _CommunityPostPageState();
}

class _CommunityPostPageState extends State<CommunityPostPage> {
  final reply = TextEditingController();
  late Future<List<CommunityReply>> replies;
  @override void initState() { super.initState(); replies = widget.repository.replies(widget.post.id); }

  Future<void> _helpful() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return _needLogin();
    await widget.repository.markHelpful(widget.post.id, user.uid);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('شكرًا، سجلنا إنه مفيد')));
  }

  Future<void> _report() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return _needLogin();
    await widget.repository.reportContent(targetType: 'communityPost', targetId: widget.post.id, reason: 'userReport', reporterId: user.uid);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال البلاغ للمراجعة')));
  }

  Future<void> _sendReply() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return _needLogin();
    if (reply.text.trim().length < 2) return;
    await widget.repository.publishReply(CommunityReply(
      id: '', postId: widget.post.id, authorId: user.uid, authorName: user.displayName ?? 'مستخدم ديرب',
      authorType: CommunityAuthorType.user, body: reply.text.trim(), createdAt: DateTime.now(),
    ));
    reply.clear();
    setState(() => replies = widget.repository.replies(widget.post.id));
  }

  void _needLogin() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('سجّل الدخول أولاً')));

  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('تفاصيل السؤال'), actions: [PopupMenuButton<String>(onSelected: (_) => _report(), itemBuilder: (_) => const [PopupMenuItem(value: 'report', child: Text('إبلاغ عن المحتوى'))])]),
    body: Column(children: [
      Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
        Text(widget.post.title, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)), const SizedBox(height: 9),
        Text(widget.post.body, style: const TextStyle(fontSize: 16, height: 1.6)), const SizedBox(height: 12),
        Align(alignment: AlignmentDirectional.centerStart, child: OutlinedButton.icon(onPressed: _helpful, icon: const Icon(Icons.thumb_up_alt_outlined), label: Text('${widget.post.helpfulCount} مفيد'))),
        const Divider(height: 32), const Text('الردود', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)), const SizedBox(height: 10),
        FutureBuilder<List<CommunityReply>>(future: replies, builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final values = snapshot.data ?? const <CommunityReply>[];
          if (values.isEmpty) return const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('لسه مفيش ردود')));
          return Column(
            children: values
                .map((item) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(child: Icon(Icons.person_rounded)),
                      title: Row(children: [
                        Text(item.authorName),
                        if (item.authorType == CommunityAuthorType.merchant)
                          const Padding(
                            padding: EdgeInsetsDirectional.only(start: 6),
                            child: Icon(Icons.store_rounded, size: 16),
                          ),
                      ]),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(item.body, style: const TextStyle(height: 1.4)),
                      ),
                    ))
                .toList(),
          );
        }),
      ])),
      SafeArea(top: false, child: Padding(padding: const EdgeInsets.fromLTRB(12, 8, 12, 10), child: Row(children: [Expanded(child: TextField(controller: reply, decoration: const InputDecoration(hintText: 'اكتب ردك...', filled: true, border: OutlineInputBorder(borderSide: BorderSide.none)))), const SizedBox(width: 8), IconButton.filled(onPressed: _sendReply, icon: const Icon(Icons.send_rounded))]))),
    ]),
  );
}
