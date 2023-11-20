abstract class BaseValueConverter<T1, T2, T3, T4> {
  T1 convert(T2 value);
  T3 convertBack(T4 value);
}
