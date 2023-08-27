/// [Result] is meant to handle errors in a way that makes the possibility of 
/// errors visible by returning a [Result]. It also provides methods to handle 
/// it. This library is an incomplete dart implementation of rusts results.
sealed class Result<O, E> {
  /// Wraps the return value of [fn] into an [Ok]. If fn throws an [Excpetion] or [Error] it is
  /// wrapped into an [Err].
  static Result<O, Object> catchErrors<O>(O Function() fn) {
    try {
      return Ok(fn());
    } catch (e) {
      return Err(e);
    }
  }

  bool isErr();
  bool isOk();

  /// Returns the [value] if this [Result] is an [Ok]. If it is an [Err] it throws
  /// with the [msg] as message.
  O expect(String msg);

  /// Returns the [value] of an [Ok] object. If it is an [Err] object intead, it throws 
  /// an Exception with the [error] as the message that is wrapped by the [Err].
  O unwrap();

  /// Returns the [value] of an [Ok] object. If it is an [Err] object, the defaultValue
  /// is returned instead.
  O unwrapOr(O defaultValue);

  Result<O2, E> andThen<O2>(Result<O2, E> Function(O ok) fn);
  Result<O, E2> orElse<E2>(Result<O, E2> Function(E err) fn);
}

class Ok<O, E> extends Result<O, E> {
  O value;

  Ok(this.value);

  @override
  bool isErr() => false;

  @override
  bool isOk() => true;

  @override
  O expect(String msg) => value;

  @override
  O unwrap() => value;

  @override
  O unwrapOr(O defaultValue) => value;

  @override
  Result<O2, E> andThen<O2>(Result<O2, E> Function(O ok) fn) => fn(value);

  @override
  Result<O, E2> orElse<E2>(Result<O, E2> Function(E err) fn) => Ok(value);

  @override 
  String toString() => "$runtimeType($value)";
}

class Err<O, E> extends Result<O, E> {
  E error;

  Err(this.error);

  @override
  bool isErr() => true;

  @override
  bool isOk() => false;

  @override
  O expect(String msg) => throw Exception(msg);

  @override
  O unwrap() => throw Exception(error);

  @override
  O unwrapOr(O defaultValue) => defaultValue;

  @override
  Result<O2, E> andThen<O2>(Result<O2, E> Function(O ok) fn) => Err(error);

  @override
  Result<O, E2> orElse<E2>(Result<O, E2> Function(E err) fn) => fn(error);

  @override 
  String toString() => "$runtimeType($error)";
}
