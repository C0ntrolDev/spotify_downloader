abstract class ValueConverter<T1, T2> {
  T2 convert(T1 value);
  T1 convertBack(T2 value);
}