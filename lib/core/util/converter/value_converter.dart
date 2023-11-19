abstract class ValueConverter<T1, T2> {
  T1 convert(T2 value);
  T2 convertBack(T1 value);
}