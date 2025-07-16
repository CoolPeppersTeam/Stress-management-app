import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart'; // проверь, что здесь есть метод addSession
import 'home_screen.dart';
import '../models/advice.dart';
import 'success_screen.dart';
import '../generated/l10n.dart';

class AddSessionScreen extends StatefulWidget {
  const AddSessionScreen({super.key});


  @override
  State<AddSessionScreen> createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  final _descriptionController = TextEditingController();
  double _stressLevel = 5;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  Color _progressColor = Colors.blue;
  Timer? _colorTimer;

  void _startColorAnimation() {
    _progressColor = Colors.blue;
    _colorTimer?.cancel();
    _colorTimer = Timer.periodic(const Duration(milliseconds: 350), (timer) {
      if (!_isLoading) {
        timer.cancel();
        return;
      }
      setState(() {
        _progressColor = _progressColor == Colors.blue ? Colors.green : Colors.blue;
      });
    });
  }

  @override
  void dispose() {
    _colorTimer?.cancel();
    super.dispose();
  }

  void _submit() {
    final desc = _descriptionController.text.trim();
    if (desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).errorEmptyDescription),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    _startColorAnimation();

    Future.delayed(Duration.zero, () async {
      try {
        await AuthService().addSession(desc, _stressLevel.toInt(), _selectedDate);

        Advice advice;
        try {
          advice = await AuthService().getAIAdvice(desc, _stressLevel.toInt(), _selectedDate);
        } catch (e) {
          advice = Advice(id: 0, title: 'AI недоступен', description: 'Рекомендация недоступна. Сессия сохранена!');
        }

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SuccessScreen(advice: advice),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при сохранении сессии: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).addSession)),
      body: _isLoading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).pleaseWait,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: LinearProgressIndicator(
                    minHeight: 28,
                    backgroundColor: Colors.grey[300],
                    color: _progressColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: loc.descriptionLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 3,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(S.of(context).stressLevelLabel),
                Expanded(
                  child: Slider(
                    value: _stressLevel,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: _stressLevel.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _stressLevel = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(S
                    .of(context)
                    .dateLabel(DateFormat.yMMMd().format(_selectedDate))),
                const Spacer(),
                TextButton(
                  onPressed: _pickDate,
                  child: Text(
                    loc.changeDate,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                loc.save,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
          ),
    );
  }
}
