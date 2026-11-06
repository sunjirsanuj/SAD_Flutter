
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/zikir.dart';
import '../providers/zikir_provider.dart';

class ZikirFormScreen extends StatefulWidget {
  final Zikir? zikir;

  const ZikirFormScreen({super.key, this.zikir});

  @override
  State<ZikirFormScreen> createState() => _ZikirFormScreenState();
}

class _ZikirFormScreenState extends State<ZikirFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _name;
  late final TextEditingController _target;
  late final TextEditingController _daily;
  late final TextEditingController _note;

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    final z = widget.zikir;

    _name = TextEditingController(text: z?.name ?? '');
    _target = TextEditingController(text: z?.target.toString() ?? '');
    _daily = TextEditingController(
      text: z?.dailyTarget?.toString() ?? '',
    );
    _note = TextEditingController(text: z?.note ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    _daily.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;

    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      final z = Zikir(
        id: widget.zikir?.id,
        name: _name.text.trim(),
        target: int.parse(_target.text),
        dailyTarget: _daily.text.trim().isEmpty
            ? null
            : int.parse(_daily.text),
        note: _note.text.trim().isEmpty
            ? null
            : _note.text.trim(),
        createdAt: widget.zikir?.createdAt ?? DateTime.now(),
        isActive: widget.zikir?.isActive ?? true,
      );

      final provider = context.read<ZikirProvider>();

      if (widget.zikir == null) {
        await provider.addZikir(z);
      } else {
        await provider.updateZikir(z);
      }

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e, stackTrace) {
      debugPrint('Save Zikir error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save Zikir: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  String? _positive(String? value, {bool optional = false}) {
    if (optional && (value == null || value.trim().isEmpty)) {
      return null;
    }

    final n = int.tryParse(value ?? '');

    if (n == null || n <= 0) {
      return 'Enter a number greater than zero';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.zikir != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Edit Zikir' : 'Create Zikir'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE7F3EE),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Color(0xFF174B3B),
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Create a goal for the Zikir you want to track.',
                      style: TextStyle(
                        color: Color(0xFF174B3B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Zikir name',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                hintText: 'e.g. SubhanAllah',
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty
                      ? 'Enter a Zikir name'
                      : null,
            ),

            const SizedBox(height: 18),

            const Text(
              'Overall target',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: _target,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'e.g. 10000',
              ),
              validator: _positive,
            ),

            const SizedBox(height: 18),

            const Text(
              'Daily target (optional)',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: _daily,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'e.g. 100',
              ),
              validator: (v) => _positive(v, optional: true),
            ),

            const SizedBox(height: 18),

            const Text(
              'Note (optional)',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: _note,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Add a personal note...',
              ),
            ),

            const SizedBox(height: 28),

            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(editing ? 'Save changes' : 'Create Zikir'),
            ),
          ],
        ),
      ),
    );
  }
}
