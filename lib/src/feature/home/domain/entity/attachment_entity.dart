import 'package:equatable/equatable.dart';

class AttachmentEntity extends Equatable {
  final String url;
  final String? originalName;
  final String? mimeType;
  final int? size;
  final double? height;
  final double? width;

  const AttachmentEntity({
    required this.url,
    this.originalName,
    this.mimeType,
    this.size,
    this.height,
    this.width,
  });

  @override
  List<Object?> get props => [url];
}
