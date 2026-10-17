enum ExportFormat {

  jpeg,

  pngOpaque,

  pngTransparent,

  svg,

}



extension ExportFormatX on ExportFormat {

  /// Formats that require a rewarded ad to unlock in V1.

  bool get isPremium => this == ExportFormat.pngTransparent;



  /// Kept in the export sheet for discovery; not unlockable in V1.

  bool get isComingSoon => this == ExportFormat.svg;



  String get fileExtension => switch (this) {

        ExportFormat.jpeg => 'jpg',

        ExportFormat.pngOpaque || ExportFormat.pngTransparent => 'png',

        ExportFormat.svg => 'svg',

      };



  String get mimeType => switch (this) {

        ExportFormat.jpeg => 'image/jpeg',

        ExportFormat.pngOpaque || ExportFormat.pngTransparent => 'image/png',

        ExportFormat.svg => 'image/svg+xml',

      };

}

