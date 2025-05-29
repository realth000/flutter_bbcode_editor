import 'package:flutter/material.dart';

/// Container of any embed pieces.
class EmbedPieceContainer extends StatelessWidget {
  /// Constructor.
  const EmbedPieceContainer({required this.child, this.onTap, super.key});

  /// Embed widget as child.
  final Widget child;

  /// Callback when tapped.
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 40),
      child: Card(
        margin: EdgeInsets.zero,
        // color: Colors.transparent,
        // shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        shape: const Border(),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), child: child),
        ),
      ),
    );
  }
}
