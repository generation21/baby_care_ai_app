import 'package:flutter/material.dart';

import '../../services/network_status_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class NetworkStatusBanner extends StatelessWidget {
  final Widget child;

  const NetworkStatusBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: NetworkStatusService.instance.isOfflineListenable,
      builder: (context, isOffline, _) {
        return Column(
          children: [
            if (isOffline)
              Container(
                width: double.infinity,
                color: AppColors.warning,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.wifi_off_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '오프라인 상태입니다. 네트워크 연결을 확인해주세요.',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}
