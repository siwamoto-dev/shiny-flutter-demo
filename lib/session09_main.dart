// Shiny-lab AI x Flutter Seminar Session 09
// A tiny memo app with on-device key-value storage.
// For class demonstrations only: do not enter secrets or sensitive records.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Session09MemoApp());
}

class Session09MemoApp extends StatelessWidget {
  const Session09MemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '第9回 ひとことメモ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MemoPage(),
    );
  }
}

class MemoPage extends StatefulWidget {
  const MemoPage({super.key});

  @override
  State<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  static const String memoKey = 'session09.savedMemo.v1';
  final SharedPreferencesAsync _storage = SharedPreferencesAsync();
  final TextEditingController _input = TextEditingController();

  bool _busy = true;
  String _savedMemo = '';
  String _status = '端末に保存されたメモを確認しています…';

  @override
  void initState() {
    super.initState();
    _loadMemo();
  }

  Future<void> _loadMemo() async {
    try {
      final String? value = await _storage.getString(memoKey);
      if (!mounted) return;
      _input.text = value ?? '';
      setState(() {
        _savedMemo = value ?? '';
        _status = value == null ? 'まだ保存されたメモはありません' : '前回のメモを復元しました';
        _busy = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _status = '読み込みに失敗しました: $error';
      });
    }
  }

  Future<void> _saveMemo() async {
    final String value = _input.text.trim();
    if (value.isEmpty) {
      setState(() => _status = 'メモを入力してから保存してください');
      return;
    }
    setState(() => _busy = true);
    try {
      await _storage.setString(memoKey, value);
      if (!mounted) return;
      setState(() {
        _savedMemo = value;
        _status = '保存処理が完了しました。アプリを終了して開き直してみよう！';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _status = '保存に失敗しました: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteMemo() async {
    setState(() => _busy = true);
    try {
      await _storage.remove(memoKey);
      if (!mounted) return;
      _input.clear();
      setState(() {
        _savedMemo = '';
        _status = '保存したメモを削除しました';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _status = '削除に失敗しました: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('第9回｜ひとことメモ')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text('今日のひとことを記録しよう',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('メモを書いて「保存」。アプリを閉じて開き直しても残るかな？'),
              const SizedBox(height: 22),
              TextField(
                controller: _input,
                enabled: !_busy,
                minLines: 2,
                maxLines: 3,
                maxLength: 120,
                decoration: const InputDecoration(
                  labelText: 'ひとことメモ',
                  hintText: '例：週末に買うものは牛乳とパン',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  FilledButton.icon(
                    onPressed: _busy ? null : _saveMemo,
                    icon: const Icon(Icons.save),
                    label: const Text('メモを保存'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _busy ? null : _deleteMemo,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('保存メモを削除'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Semantics(
                liveRegion: true,
                child: Text(_status, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('端末に保存したメモ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      const SizedBox(height: 8),
                      Text(_savedMemo.isEmpty ? '（保存メモなし）' : _savedMemo),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text('※ 練習用です。パスワードや個人情報など重要なデータは入力しないでください。',
                  style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
