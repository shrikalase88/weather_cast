import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/pin_provider.dart';
import '../widgets/skeu_button.dart';
import '../core/theme/colors.dart';

class PinScreen extends ConsumerStatefulWidget {
  const PinScreen({super.key});

  @override
  ConsumerState<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinScreen> {
  String _input = '';
  String _firstAttempt = '';
  bool _isConfirming = false;

  void _onKeyTap(String key) {
    if (_input.length < 4) {
      setState(() {
        _input += key;
      });
      if (_input.length == 4) {
        _handleComplete();
      }
    }
  }

  void _onBackspace() {
    if (_input.isNotEmpty) {
      setState(() {
        _input = _input.substring(0, _input.length - 1);
      });
    }
  }

  Future<void> _handleComplete() async {
    final status = ref.read(pinProvider).status;

    if (status == PinStatus.notSet) {
      if (!_isConfirming) {
        setState(() {
          _firstAttempt = _input;
          _input = '';
          _isConfirming = true;
        });
      } else {
        if (_input == _firstAttempt) {
          await ref.read(pinProvider.notifier).setPin(_input);
          if (mounted) context.go('/');
        } else {
          _showError('PINs do not match');
          setState(() {
            _input = '';
            _isConfirming = false;
            _firstAttempt = '';
          });
        }
      }
    } else {
      final success = await ref.read(pinProvider.notifier).validatePin(_input);
      if (success) {
        if (mounted) context.go('/');
      } else {
        _showError('Incorrect PIN');
        setState(() {
          _input = '';
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(pinProvider).status;
    final title = status == PinStatus.notSet
        ? (_isConfirming ? 'Confirm PIN' : 'Create 4-Digit PIN')
        : 'Enter App PIN';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) => _buildDot(index)),
            ),
            const Spacer(),
            _buildKeypad(),
            if (status != PinStatus.notSet && ref.watch(pinProvider).attempts >= 3)
              TextButton(
                onPressed: () => ref.read(pinProvider.notifier).resetPin(),
                child: const Text('Forgot PIN?', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    bool active = _input.length > index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        boxShadow: active
            ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ]
            : null,
        border: Border.all(color: AppColors.shadowLight, width: 2),
      ),
      child: active
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildKeypad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: [
          ...['1', '2', '3', '4', '5', '6', '7', '8', '9'].map((k) => _buildKey(k)),
          const SizedBox.shrink(),
          _buildKey('0'),
          IconButton(
            onPressed: _onBackspace,
            icon: const Icon(Icons.backspace_outlined, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String label) {
    return SkeuButton(
      onTap: () => _onKeyTap(label),
      borderRadius: 50,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
