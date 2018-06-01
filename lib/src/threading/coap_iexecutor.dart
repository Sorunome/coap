/*
 * Package : Coap
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 08/04/2018
 * Copyright :  S.Hamblett
 */

part of coap;

typedef void Action();
typedef void ActionGeneric<T>();

/// Provides methods to execute tasks.
abstract class CoapIExecutor {

  /// Starts a task without parameter.
  void start(Action task);

  /// Starts a task with a parameter.
  void Start(ActionGeneric<Object> task, Object obj);
}
