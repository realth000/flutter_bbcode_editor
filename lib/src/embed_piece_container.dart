import 'package:flutter/material.dart';

/// Type of the embed piece in editor ui.
enum EmbedPieceType {
  /// Header piece of the separated embed.
  ///
  /// Have border radius on top border corners.
  header,

  /// Tail piece of the separated embed.
  ///
  /// Have border radius on bottom border corners.
  tail,
}

/// Container of any embed pieces.
class EmbedPieceContainer extends StatelessWidget {
  /// Constructor.
  const EmbedPieceContainer({required this.pieceType, required this.child, this.onTap, super.key});

  /// The type of embed piece.
  ///
  /// Decide border style.
  final EmbedPieceType pieceType;

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
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          // pieceType == EmbedPieceType.header
          //     ? const BorderRadius.all(Radius.circular(8))
          //     : const BorderRadius.all(Radius.circular(8)),
        ),
        // shape: const Border(),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), child: child),
        ),
      ),
    );
  }
}
