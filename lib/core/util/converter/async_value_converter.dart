abstract class AsyncValueConverter<T1, T2> {
  Future<T2> convert(T1 value);
  Future<T1> convertBack(T2 value);
}