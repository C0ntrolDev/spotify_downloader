class Result<Failure, Type> {
  
  const Result.isSuccessful(this.result) : isSuccessful = true, failure = null;
  const Result.notSuccessful(this.failure) : isSuccessful = false, result = null;

  final bool isSuccessful;
  final Type? result;
  final Failure? failure;
}
