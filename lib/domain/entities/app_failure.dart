import 'package:equatable/equatable.dart';

enum AppFailureCode {
  emptyInput,
  invalidUrl,
  wifiSsidRequired,
  contactNameRequired,
  eanInvalidLength,
  eanInvalidChecksum,
  eanNonNumeric,
  code128Empty,
  code128IllegalChar,
  exportFailed,
  shareFailed,
  saveFailed,
  adUnavailable,
  adNotEarned,
  offlineAds,
  cameraDenied,
  cameraPermanentlyDenied,
  contactsDenied,
  contactsPermanentlyDenied,
  contactPickCancelled,
  contactPickFailed,
  invalidSocialInput,
  scannerFailed,
  unsupportedFormat,
  qrTooLarge,
  generic,
}

class AppFailure extends Equatable {
  const AppFailure(this.code, {this.details});

  final AppFailureCode code;
  final String? details;

  @override
  List<Object?> get props => [code, details];
}

sealed class Result<T> {
  const Result();

  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;

  T? get valueOrNull => switch (this) {
        Ok<T>(:final value) => value,
        Err<T>() => null,
      };

  AppFailure? get failureOrNull => switch (this) {
        Ok<T>() => null,
        Err<T>(:final failure) => failure,
      };

  R when<R>({
    required R Function(T value) ok,
    required R Function(AppFailure failure) err,
  }) {
    return switch (this) {
      Ok<T>(:final value) => ok(value),
      Err<T>(:final failure) => err(failure),
    };
  }
}

class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

class Err<T> extends Result<T> {
  const Err(this.failure);
  final AppFailure failure;
}
