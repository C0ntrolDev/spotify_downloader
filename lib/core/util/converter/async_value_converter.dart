abstract class AsyncValueConverter<T1, T2> {
  Future<T1> convert(T2 value);
  Future<T2> convertBack(T1 value);
}