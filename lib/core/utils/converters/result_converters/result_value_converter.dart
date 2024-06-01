import 'package:spotify_downloader/core/utils/converters/base_value_converter.dart/base_value_converter.dart';
import 'package:spotify_downloader/core/utils/failures/failures.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';

abstract class ResultValueConverter<T1, T2>
    implements BaseValueConverter<Result<ConverterFailure, T1>, T2, Result<ConverterFailure, T2>, T1> {}
