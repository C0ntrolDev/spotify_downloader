import 'package:spotify_downloader/core/util/converters/base_value_converter.dart/base_value_converter.dart';

abstract class AsyncValueConverter<T1, T2> implements BaseValueConverter<Future<T1>, T2, Future<T2>, T1> {}
