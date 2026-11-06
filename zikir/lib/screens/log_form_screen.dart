import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/zikir.dart';
import '../models/zikir_log.dart';
import '../providers/zikir_provider.dart';

class LogFormScreen extends StatefulWidget {
  final Zikir zikir;
  final ZikirLog? log;
  const LogFormScreen({super.key, required this.zikir, this.log});

  @override
  State<LogFormScreen> createState() => _LogFormScreenState();
}

class _LogFormScreenState extends State<LogFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _count;
  late final TextEditingController _note;
  late DateTime _dateTime;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _count = TextEditingController(text: widget.log?.count.toString() ?? '');
    _note = TextEditingController(text: widget.log?.note ?? '');
    _dateTime = widget.log?.performedAt ?? DateTime.now();
  }

  @override
  void dispose() { _count.dispose(); _note.dispose(); super.dispose(); }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && mounted) {
      setState(() => _dateTime = DateTime(
        picked.year, picked.month, picked.day, _dateTime.hour, _dateTime.minute,
      ));
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime),
    );
    if (picked != null && mounted) {
      setState(() => _dateTime = DateTime(
        _dateTime.year, _dateTime.month, _dateTime.day, picked.hour, picked.minute,
      ));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final log = ZikirLog(
      id: widget.log?.id,
      zikirId: widget.zikir.id!,
      count: int.parse(_count.text),
      performedAt: _dateTime,
      note: _note.text.trim().isEmpty ? null : _note.text.trim(),
    );
    final provider = context.read<ZikirProvider>();
    if (widget.log == null) {
      await provider.addLog(log);
    } else {
      await provider.updateLog(log);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.log != null;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Edit entry' : 'Record Zikir')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE7F3EE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('ZIKIR ACTIVITY', style: TextStyle(
                  fontSize: 11, letterSpacing: 1.3, fontWeight: FontWeight.w800,
                  color: Color(0xFF23866A),
                )),
                const SizedBox(height: 7),
                Text(widget.zikir.name, style: const TextStyle(
                  fontSize: 23, fontWeight: FontWeight.w800, color: Color(0xFF174B3B),
                )),
                const SizedBox(height: 5),
                const Text('Enter the total you completed outside the app.',
                  style: TextStyle(color: Color(0xFF47685A))),
              ]),
            ),
            const SizedBox(height: 24),
            const Text('Completed count', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _count,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'e.g. 500', suffixText: 'times'),
              validator: (v) {
                final n = int.tryParse(v ?? '');
                return n == null || n <= 0 ? 'Enter a count greater than zero' : null;
              },
            ),
            const SizedBox(height: 20),
            const Text('Date and time', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(DateFormat('dd MMM yyyy').format(_dateTime)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF174B3B),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              )),
              const SizedBox(width: 10),
              Expanded(child: OutlinedButton.icon(
                onPressed: _pickTime,
                icon: const Icon(Icons.access_time),
                label: Text(DateFormat('hh:mm a').format(_dateTime)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF174B3B),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              )),
            ]),
            const SizedBox(height: 20),
            const Text('Note (optional)', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _note,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'e.g. After Fajr prayer'),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: Text(_saving ? 'Saving...' : editing ? 'Save changes' : 'Save activity'),
            ),
          ],
        ),
      ),
    );
  }
}
