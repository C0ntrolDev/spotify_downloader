import 'package:spotify_downloader/core/utils/converters/base_value_converter.dart/base_value_converter.dart';

abstract class ConverterWithParameter<T1, T2, T3> extends BaseValueConverter<T1, (T2, T3), T2 , (T1, T3)> {

}