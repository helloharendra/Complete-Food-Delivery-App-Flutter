import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dierb_core/dierb_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../data/firestore_dierb_repositories.dart';
import '../widgets/dierb_states.dart';
import 'community_post_page.dart';

class AskDierbPage extends StatefulWidget {
  const AskDierbPage({super.key});
  @override
  State<AskDierbPage> createState() => _AskDierbPageState();
}

class _AskDierbPageState extends State<AskDierbPage> {
  PageResult<CommunityPost>? page;
  bool loading = true;
  String? error;
  CommunityPostType? filter;

  FirestoreCommunityRepository? get repository => Firebase.apps.isEmpty ? null : FirestoreCommunityRepository(FirebaseFirestore.instance);

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { loading = true; error = null; });
    final repo = repository;
    if (repo == null) {
      setState(() { loading = false; page = const PageResult(items: <CommunityPost>[], hasMore: false); });
      return;
    }
    try {
      final result = await repo.publishedPosts(const LocationRef(cityId: LaunchLocationDefaults.cityId), const PageRequest(), type: filter);
      if (mounted) setState(() { page = result; loading = false; });
    } on FirebaseException catch (exception) {
      if (mounted) setState(() { loading = false; error = 'تعذر تحميل الأسئلة (${exception.code}). حاول مرة أخرى.'; });
    } catch (exception) {
      if (mounted) setState(() { loading = false; error = 'تعذر قراءة بيانات الأسئلة: $exception'; });
    }
  }

  Future<void> _openComposer() async {
    if (Firebase.apps.isEmpty || FirebaseAuth.instance.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('سجّل الدخول أولاً علشان تسأل أهل ديرب')));
      return;
    }
    final created = await showModalBottomSheet<bool>(
      context: context, isScrollControlled: true, useSafeArea: true,
      builder: (_) => CommunityComposer(repository: repository!),
    );
    if (created == true) _load();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text('اسأل أهل ديرب', style: TextStyle(fontWeight: FontWeight.w900)), actions: [IconButton(onPressed: _load, icon: const Icon(Icons.refresh_rounded))]),
          floatingActionButton: FloatingActionButton.extended(onPressed: _openComposer, icon: const Icon(Icons.add_comment_rounded), label: const Text('اسأل دلوقتي')),
          body: Column(children: [
            SizedBox(height: 54, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), children: [
              _FilterChip(label: 'الكل', selected: filter == null, onTap: () { filter = null; _load(); }),
              ...CommunityPostType.values.map((type) => _FilterChip(label: _postTypeLabel(type), selected: filter == type, onTap: () { filter = type; _load(); })),
            ])),
            Expanded(child: _body()),
          ]),
        ),
      );

  Widget _body() {
    if (loading) return const _PostSkeletons();
    if (error != null) return _MessageState(icon: Icons.cloud_off_rounded, title: error!, action: _load);
    if (page == null || page!.items.isEmpty) return const _MessageState(icon: Icons.forum_outlined, title: 'لسه مفيش أسئلة هنا\nكن أول واحد يسأل أهل ديرب');
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 100), itemCount: page!.items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) => CommunityPostCard(post: page!.items[index], repository: repository!, onChanged: _load),
      ),
    );
  }
}

class CommunityPostCard extends StatelessWidget {
  const CommunityPostCard({super.key, required this.post, required this.repository, required this.onChanged});
  final CommunityPost post;
  final FirestoreCommunityRepository repository;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CommunityPostPage(post: post, repository: repository))).then((_) => onChanged()),
        child: Container(
          padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const CircleAvatar(child: Icon(Icons.person_rounded)), const SizedBox(width: 9),
              Expanded(child: Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.w800))),
              if (post.authorType == CommunityAuthorType.merchant) const _Badge(text: 'تاجر'),
              if (post.authorVerified) const Padding(padding: EdgeInsetsDirectional.only(start: 5), child: Icon(Icons.verified_rounded, size: 18, color: Color(0xFF166534))),
            ]),
            const SizedBox(height: 12),
            Text(post.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
            if (post.body.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6), child: Text(post.body, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(height: 1.5))),
            const SizedBox(height: 13),
            Row(children: [
              const Icon(Icons.thumb_up_alt_outlined, size: 18), Text(' ${post.helpfulCount} مفيد'), const SizedBox(width: 18),
              const Icon(Icons.chat_bubble_outline_rounded, size: 18), Text(' ${post.replyCount} رد'),
              const Spacer(), Text(_postTypeLabel(post.type), style: const TextStyle(color: Color(0xFF166534), fontWeight: FontWeight.w700)),
            ]),
          ]),
        ),
      );
}

class CommunityComposer extends StatefulWidget {
  const CommunityComposer({super.key, required this.repository});
  final FirestoreCommunityRepository repository;
  @override
  State<CommunityComposer> createState() => _CommunityComposerState();
}

class _CommunityComposerState extends State<CommunityComposer> {
  final title = TextEditingController();
  final body = TextEditingController();
  CommunityPostType type = CommunityPostType.question;
  bool saving = false;
  String? error;

  Future<void> _save() async {
    if (title.text.trim().length < 5 || body.text.trim().length < 5) return;
    final user = FirebaseAuth.instance.currentUser!;
    setState(() { saving = true; error = null; });
    try {
      final now = DateTime.now();
      await widget.repository.publishPost(CommunityPost(
        id: '', authorId: user.uid, authorName: user.displayName ?? 'مستخدم ديرب', authorType: CommunityAuthorType.user,
        title: title.text.trim(), body: body.text.trim(), type: type, cityId: LaunchLocationDefaults.cityId,
        createdAt: now, updatedAt: now,
      ));
      if (mounted) Navigator.pop(context, true);
    } on FirebaseException catch (exception) {
      if (mounted) setState(() => error = firestoreErrorMessage(exception));
    } catch (_) {
      if (mounted) setState(() => error = 'تعذر نشر السؤال الآن. حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(18, 16, 18, MediaQuery.viewInsetsOf(context).bottom + 18),
        child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('اسأل أهل ديرب', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)), const SizedBox(height: 14),
          DropdownButtonFormField<CommunityPostType>(initialValue: type, items: CommunityPostType.values.map((value) => DropdownMenuItem(value: value, child: Text(_postTypeLabel(value)))).toList(), onChanged: (value) => setState(() => type = value!)),
          const SizedBox(height: 12), TextField(controller: title, decoration: const InputDecoration(labelText: 'عنوان السؤال', border: OutlineInputBorder())),
          const SizedBox(height: 12), TextField(controller: body, minLines: 4, maxLines: 7, decoration: const InputDecoration(labelText: 'اكتب التفاصيل', border: OutlineInputBorder())),
          if (error != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(error!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
          const SizedBox(height: 16), FilledButton.icon(onPressed: saving ? null : _save, icon: saving ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send_rounded), label: const Text('نشر السؤال')),
        ])),
      );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});
  final String label; final bool selected; final VoidCallback onTap;
  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsetsDirectional.only(end: 7), child: ChoiceChip(label: Text(label), selected: selected, onSelected: (_) => onTap()));
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text}); final String text;
  @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3), decoration: BoxDecoration(color: const Color(0xFFE0F2E9), borderRadius: BorderRadius.circular(8)), child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)));
}

class _PostSkeletons extends StatelessWidget {
  const _PostSkeletons();
  @override Widget build(BuildContext context) => ListView.builder(padding: const EdgeInsets.all(14), itemCount: 5, itemBuilder: (_, __) => Container(height: 150, margin: const EdgeInsets.only(bottom: 10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))));
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.icon, required this.title, this.action});
  final IconData icon; final String title; final VoidCallback? action;
  @override Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 56, color: Colors.grey), const SizedBox(height: 12), Text(title, textAlign: TextAlign.center), if (action != null) TextButton(onPressed: action, child: const Text('حاول تاني'))]));
}

String _postTypeLabel(CommunityPostType type) {
  switch (type) {
    case CommunityPostType.question: return 'سؤال';
    case CommunityPostType.productRequest: return 'طلب منتج';
    case CommunityPostType.serviceRequest: return 'طلب خدمة';
    case CommunityPostType.localInquiry: return 'استفسار محلي';
    case CommunityPostType.recommendation: return 'طلب توصية';
    case CommunityPostType.propertyRequest: return 'طلب عقار';
    case CommunityPostType.jobRequest: return 'طلب وظيفة';
  }
}
