import 'package:chat/src/feature/home/domain/entity/attachment_entity.dart';

class AttachmentModel extends AttachmentEntity {
  const AttachmentModel({
    required super.url,
    super.originalName,
    super.mimeType,
    super.size,
    super.height,
    super.width,
  });

  factory AttachmentModel.fromMap(Map<String, dynamic> json) {
    return AttachmentModel(
      url: json['url'] as String,
      originalName: json['originalName'] as String?,
      mimeType: json['mimetype'] as String?,
      size: json['size'] as int?,
      height: (json['height'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
    );
  }
}
