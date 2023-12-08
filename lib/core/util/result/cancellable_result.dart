class CancellableResult<Failure, Type> {
  
  const CancellableResult.isCancelled() : isCancelled = true, isSuccessful = false, failure = null, result = null;
  const CancellableResult.isSuccessful(this.result) : isCancelled = false, isSuccessful = true, failure = null;
  const CancellableResult.notSuccessful(this.failure) : isCancelled = false,  isSuccessful = false, result = null;

  final bool isSuccessful;
  final bool isCancelled;
  
  final Type? result;
  final Failure? failure;
}