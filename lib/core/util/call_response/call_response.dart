class CallResponse<Failure, Type> {
  
  CallResponse.isSuccessful({required this.response}) : isSuccessful = true;
  CallResponse.notSuccessful({required this.failure}) : isSuccessful = false;

  bool isSuccessful;
  Type? response;
  Failure? failure;
}
